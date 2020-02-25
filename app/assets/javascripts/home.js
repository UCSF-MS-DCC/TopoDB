// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load',function() {
    $('.strain-datatable').each(function(idx) {
      var url = $(this).data('source')+"&cage_type="+$(this).data('cagetype')
      $("#"+$(this).prop("id")).dataTable({
          "processing": true,
          "serverSide": true,
          "ajax": {
              "url": url
          },
          "pagingType": "full_numbers",
          "columns": [
              {"data": "cage_number"},
              {"data": "cage_type"},
              {"data": "genotype"},
              {"data": "dob"},
              {"data": "number_mice"}
          ],
          "language": {
            "paginate": {
              "previous": "<<-",
              "next": "->>"
            }
          }
      })
    });

    $('#removed-mice-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
          "url": $('#removed-mice-datatable').data('source')
      },
      "pagingType": "full_numbers",
      "order":[[5, "desc"]],
      "columns": [
        {"data": "sex"},
        {"data": "designation"},
        {"data": "ear_punch"},
        {"data": "cage"},
        {"data": "strain"},
        {"data": "genotype"},
        {"data": "removed"},
        {"data": "removed_for"},
        {"data": "restore"},
        {"data": "mouseid"}
      ],
      "columnDefs": [
        {
          "targets": [9],
          "visible": false,
          "searchable": false
        },
        {
          "targets": [8],
          "render" : function( data, type, row) {
            return "<button onClick='restoreMouse("+row['mouseid']+",this)' class='btn btn-sm btn-primary' >Restore</button>"
          }
        }
      ]
      /* initComplete is a Datatables callback that fires after the table is drawn. The function below adds a checkbox to the eighth cell of each row in the table. */
      // "initComplete": function(settings, json) {
      //   $('tr td:nth-child(9)').each(function(idx) {
      //     $(this).append('<input type="checkbox" onChange="restoreMouse(this)">')
      //   });
      // }
  });
    /* Activating Best In Place */
    jQuery(".best_in_place").best_in_place();
    /* Show/hide the green check and red x in each editable cell in the best-in-place enabled table depending on the outcome of the AJAX call */
    $('.highlight-on-success').bind("ajax:success", function (e) { 
                                                                    // if (e.target.dataset.bipAttribute === "sex") {
                                                                    //   console.log(e.target.dataset.bipValue);

                                                                    // }
                                                                    if (!$(this).next("span").hasClass("hidden")) {
                                                                        $(this).next("span").addClass("hidden") 
                                                                      };
                                                                      $(this).prev("span").removeClass("hidden"); 
                                                                    });
    $('.highlight-on-success').bind("ajax:error", function () { if (!$(this).prev("span").hasClass("hidden")) { $(this).prev("span").addClass("hidden") }; $(this).next("span").removeClass("hidden"); });
    /* In breeding cage views, color code the rows that aren't pups (ie parents) */
    $('.cage-parent-row').css("background-color","greenyellow");
    
/* only run this block for the single strain view */
  if (window.location.pathname === "/home/strain") {
    var ctx = $('#sex-chart');
    var ctx2 = $('#age-chart');
    var qstring = window.location.href.split("?")[1]
    var strain, location
    qstring.split("&").forEach(function(kvpair) {if (kvpair.split("=")[0] === "location") { location = kvpair.split("=")[1] } if (kvpair.split("=")[0] === "strain") { strain = kvpair.split("=")[1] } })

    $.get("/home/graph_data_sex?strain="+strain+"&location="+location, function(data) {
      var sexChart = new Chart(ctx, {
        type: 'pie',
        data: {
          labels: ["Female", "Male"],
          datasets: [{
            label: "Sex",
            data: data["numbers"],
            backgroundColor: [
              'rgba(255,182,193,0.6)',
              'rgba(115,194,251,0.6)'
            ],
            borderColor: [
              'rgba(255,182,193,1)',
              'rgba(115,194,251,1)'
            ]
          }]
        },
        options: {
          responsive:true,
          maintainAspectRatio:false,
          rotation:5 * Math.PI,
          title: {
            display:true,
            fontSize:15,
            fontColor:'#000',
            text:"Sex (excluding breeding cages)"
          },
          legend:{
            position:'bottom',
            labels: {
              boxWidth:10
            }
          },
          scales: {}
        }
      }); /* close sexChart instantiation */
    }); /* close AJAX call to graph_data_sex endpoint */

    $.get("/home/graph_data_age?strain="+strain+"&location="+location, function(data){
      google.charts.load('current', {'packages':['treemap']});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var d = google.visualization.arrayToDataTable(data.data);

        var tree = new google.visualization.TreeMap(document.getElementById("age-chart"));
        /* Each levels' tooltips will need to be customized a little to provide the proper context and values to the user */
        /* Top level (row 0) describes the data structure */
        /* Next level (row 1) is information on the strain and its children nodes (cage_types) */
        /* Next level are the cage_types. ID values are 'single-f', 'single-m' */
        /* Next level are time frames and child nodes (cages). ID values consist of cage_type and a hyphen delimited span of months, with 'months' being the last word of the ID phrase */
        /* Last level are cages. ID values consist of cage_number and parenthises containing the time-frame */
        function showFullToolTip(row, size, value) {
          // console.log(row, size, value)
          if (!d.getValue(row,1)) {
            return '<div style="background:#000; padding:10px; border-style:solid; color:#fff">' +
            '<span><b>Strain: ' + d.getValue(row, 0).split(" ")[0] +'</b></span><br>'+
            'mice: '+d.getValue(row,2)+'</div> ';
          } else if (["single-f", "single-m"].indexOf(d.getValue(row,0)) !== -1 ) {
            return '<div style="background:#000; padding:10px; border-style:solid; color:#fff">' +
            '<span><b>Cage type: ' + d.getValue(row, 0).split(" ")[0] +'</b></span><br>'+
            'mice: '+d.getValue(row,2)+'</div> ';
          } else if (["single-f", "single-m"].indexOf(d.getValue(row,1)) !== -1 ) {
            var ageRange = d.getValue(row, 0).split(" ")
            var cat = ageRange.shift();
            var ageStr = ageRange.join(" ");
            return '<div style="background:#000; padding:10px; border-style:solid; color:#fff">' +
            '<span><b>Age of mice: ' + cat + ' months</b></span><br>'+
            'mice: '+d.getValue(row,2)+'</div> ';
          } else {
            var cageNum = d.getValue(row, 0).split("|")[0];
            var ageRange = d.getValue(row, 0).split(" ")
            var cat = ageRange.shift();
            var ageStr = ageRange.join(" ").replace("(","").replace(")","");
            return '<div style="background:#000; padding:10px; border-style:solid; color:#fff">' +
            '<span><b>Cage number: ' + cageNum +'</b></span><br>'+
            'Mice in age range: '+d.getValue(row,2)+'</div> ';
          }
        }
        tree.draw(d, {
          minColor:'#A9CCE3',
          midColor:'#5499C7',
          maxColor:'#2471A3',
          headerHeight:25,
          fontColor: 'black',
          showScale: false,
          maxDepth:1,
          maxPostDepth:3,
          generateTooltip:showFullToolTip
        });

      } /* close drawChart function definition */
    }); /* close AJAX call to graph_data_age endpoint */

  } /* close 'if (window.location.pathname === "/home/strain") {} block */
  /* only execute this function for single cage views. This code is a configuration for the d3-milestones package, which is linked to in the <head> area of layout/application */
  if (window.location.pathname === "/home/cage") {
    var cage_number = window.location.href.split("=")[1]
    $.get("/home/cage_timeline_dates?cage="+cage_number, function(data) {
      milestones('#cage-timeline')
      .mapping({
        'timestamp': 'second',
        'text': 'title'
      })
      .parseTime('%s')
      .aggregateBy('second')
      .labelFormat('%Y-%m-%d')
      .render(data.timepoints);
    }); /* close ajax get callback */
  } /* close 'if (window.location.pathname === "/home/cage") {} block */

  /* new/edit cage forms location field input selector listeners/logic here */
  $(".location-select-radio").on('click', function(obj) {
    // alert($("input[name='location-select-radio']:checked").val())
    /* if "New", disable the select menu and focus the input box, if "Existing", enable the select, and disable the input box */
    if (obj.target.value === "New") {
      $('#cage_location').prop("disabled", true);
      $('#location-input-text').prop("disabled", false);
    }
    if (obj.target.value === "Existing") {
      $('#location-input-text').prop("disabled", true);
      $('#cage_location').prop("disabled", false);
    }
   });

   /* remove mouse from cage front end code here. On modal activation, there is an AJAX call to get the most up-to-date state of the mouse to be removed. Modal body is populated with returned variables.
   A datepicker and text box allow for user input. Date is required for successful deletion of a mouse. When user clicks on the Yes, I'm sure button, another AJAX call is made to update the mouse with a removal date. */
  $('.modal').on('show.bs.modal', function(e) {
    var parsed = $(e.relatedTarget).data("dependencies");
    var mouseIdx = parsed["mouseid"];
    var mouseData;
  
    $.ajax({
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      type:"GET",
      url:"/home/mouse",
      data:{"mouse":mouseIdx},
      dataType:"json",
      success:function(reply) {;
         mouseData = reply["data"];
         $('#modal-mouse-remove-date').datepicker().datepicker("setDate", new Date());
         $('#modal-mouse-designation').text(mouseData["three_digit_code"]);
         $('#modal-mouse-sex').text(["N/A","F", "M"][mouseData["sex"]]);
         $('#modal-mouse-cage-number').text(parsed["mousecage"]);
         $('#modal-mouse-earpunch').text(["-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"][mouseData["ear_punch"]-1]);
         $('#modal-mouse-strain').text(mouseData["strain"]+":");
         $('#modal-mouse-genotype').text(["","N/A","+/+","+/-","-/-"][mouseData["genotype"]]);
         $('#modal-mouse-dob').text(mouseData["dob"]);
         if (mouseData["strain2"] != null) {
           $('#second-strain-modal-row').css("display", "flex");
           $('#modal-mouse-strain2').text(mouseData["strain2"]+":");
           $('#modal-mouse-genotype2').text(["","N/A","+/+","+/-","-/-"][mouseData["genotype2"]]);
         }
        },
      error:function(jqxhr,reply,status) { alert("Mouse data was not fetched, please notify a site administrator."); }
    });
    //AJAX call to remove_mouse controller method
    $('#destroyMouseConfirm').on('click', function(){
      var rDate = $('#modal-mouse-remove-date').val();
      var rReason = $('#modal-mouse-remove-reason').val();

      $.ajax({
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        type:"PUT",
        url:"/home/remove_mouse",
        data:{"mouse":{"mouse_id":mouseIdx, "remove_date":rDate, "remove_reason":rReason}},
        dataType:"json",
        success:function(reply) { window.location.reload(); },
        error:function(jqxhr,reply,status) { alert("Mouse was not removed, please notify a site administrator."); }
      })
    })
  });

}); /* close 'on turbolinks:load' function */

/* Datepicker jquery initialization code here */
$('#pups_birthdate').datepicker();
$('#new_mouse_birthdate').datepicker();
$.datepicker.setDefaults({
  dateFormat: 'yy-mm-dd'
});

/* clicking on the checkbox in the restore column of the removed mice table activates this function. First, the checkbox becomes disabled. Then specific values are read from the table row. Finally an AJAX call
is made to the controller method, which will set the 'removed' column to nil, "restoring" the mouse to the world of the living. */
function restoreMouse(idx, button) {
  $.ajax({
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    type:"POST",
    url:"/home/restore_mouse",
    data:{"mouse":idx},
    dataType:"json",
    success:function(reply) { alert(JSON.stringify(reply.message)); $(button).attr("disabled",true); $(button).text("Restored"); },
    error:function(jqxhr,reply,status) { alert("Mouse was not restored, please notify a site administrator."); }
  });
}

