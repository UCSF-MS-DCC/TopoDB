// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load',function() {
    $('#strain-datatable').dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": $('#strain-datatable').data('source')
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
        // pagingType is optional, if you want full pagination controls.
        // Check dataTables documentation to learn more about
        // available options.
    });

    $('#removed-mice-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
          "url": $('#removed-mice-datatable').data('source')
      },
      "pagingType": "full_numbers",
      "columns": [
          {"data": "cage"},
          {"data": "designation"},
          {"data": "strain"},
          {"data": "sex"},
          {"data": "genotype"},
          {"data": "removed"},
          {"data": "removed_for"},
          {"data": "restore"}
      ],
      /* initComplete is a Datatables callback that fires once the table is drawn and populated. The function below adds a checkbox to the eighth cell of each row in the table. */
      "initComplete": function(settings, json) {
        $('tr td:nth-child(8)').each(function(idx) {
          $(this).append('<input type="checkbox" onChange="restoreMouse(this)">')
        })
      }
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
  });
    /* Activating Best In Place */
    jQuery(".best_in_place").best_in_place();
    /* Show/hide the green check and red x in each editable cell in the best-in-place enabled table depending on the outcome of the AJAX call */
    $('.highlight-on-success').bind("ajax:success", function () { if (!$(this).next("span").hasClass("hidden")) { $(this).next("span").addClass("hidden") }; $(this).prev("span").removeClass("hidden"); });
    $('.highlight-on-success').bind("ajax:error", function () { if (!$(this).prev("span").hasClass("hidden")) { $(this).prev("span").addClass("hidden") }; $(this).next("span").removeClass("hidden"); });
    
/* only run this block for the single strain view */
  if (window.location.pathname === "/home/strain") {
    var ctx = $('#sex-chart');
    var ctx2 = $('#age-chart');
    var strain = window.location.href.split("=")[1]

    $.get("/home/graph_data_sex?strain="+strain, function(data) {
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

    $.get("/home/graph_data_age?strain="+strain, function(data){
      console.log(data)
      console.log(data.data)
      google.charts.load('current', {'packages':['treemap']});
      google.charts.setOnLoadCallback(drawChart);
      function drawChart() {
        var d = google.visualization.arrayToDataTable(data.data);

        var tree = new google.visualization.TreeMap(document.getElementById("age-chart"));
        /* Each levels' tooltips will need to be customized a little to provide the proper context and values to the user */
        /* Top level (row 0) describes the data structure */
        /* Next level (row 1) is information on the strain and its children nodes (cage_types) */
        /* Next level are the cage_types. ID values are 'breeding', 'single-f', 'single-m', and 'experiment' */
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
            console.log(row, d.getValue(row,0), d.getValue(row,1), d.getValue(row,2), d.getValue(row,3))
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
}); /* close 'on turbolinks:load' function */

/* Datepicker jquery code here */
$('#pups_birthdate').datepicker();

/* clicking on the checkbox in the restore column of the removed mice table activates this function. First, the checkbox becomes disabled. Then specific values are taken from the table row. Finally an AJAX call
is made to the controller method, which will set the 'removed' column to nil, "restoring" the mouse to the world of the living. */
function restoreMouse(obj) {
  if (obj.checked === true) {
    $(obj).prop("disabled", true); 
    var cageNumber = $(obj).parent().parent().children('td').eq(0).html();
    var mouseID = $(obj).parent().parent().children('td').eq(1).html();
    var strain = $(obj).parent().parent().children('td').eq(2).html();
    var sex = $(obj).parent().parent().children('td').eq(3).html();
    var removedDate = $(obj).parent().parent().children('td').eq(5).html();
    $.ajax({
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      type:"POST",
      url:"/home/restore_mouse",
      data:{"mouse":mouseID, "cage":cageNumber, "strain":strain, "removed":removedDate, "sex":sex},
      dataType:"json",
      success:function(reply) { alert(JSON.stringify(reply.message)); },
      error:function(jqxhr,reply,status) { alert("Mouse was not restored, please notify a site administrator."); }
    })
  }

}