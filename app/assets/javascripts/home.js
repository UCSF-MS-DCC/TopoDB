// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load',function() {
    // $('#sandler-cages-datatable').dataTable({
    //   "processing": true,
    //   "serverSide": true,
    //   "ajax": {
    //     "url": $('#cages-datatable').data('source'),
    //     "data": {"location":"sandler"}
    //   },
    //   "pagingType": "full_numbers",
    //   "columns": [
    //     {"data": "cage_number"},
    //     {"data": "strain"},
    //     {"data": "genotype"},
    //     {"data": "cage_type"}
    //   ]
    //   // pagingType is optional, if you want full pagination controls.
    //   // Check dataTables documentation to learn more about
    //   // available options.
    // });
    // $('#genentech-cages-datatable').dataTable({
    //   "processing": true,
    //   "serverSide": true,
    //   "ajax": {
    //     "url": $('#cages-datatable').data('source'),
    //     "data": {"location":"genentech hall"}
    //   },
    //   "pagingType": "full_numbers",
    //   "columns": [
    //     {"data": "cage_number"},
    //     {"data": "strain"},
    //     {"data": "genotype"},
    //     {"data": "cage_type"}
    //   ]
    //   // pagingType is optional, if you want full pagination controls.
    //   // Check dataTables documentation to learn more about
    //   // available options.
    // });
  //   $('#index-datatable').dataTable({
  //     "processing": true,
  //     "serverSide": true,
  //     "ajax": {
  //         "url": $('#index-datatable').data('source')
  //     },
  //     "pagingType": "full_numbers",
  //     "columns": [
  //         {"data": "strain"},
  //         {"data": "cages"},
  //         {"data": "mice"},
  //         {"data": "last_active"}
  //     ]
  //     // pagingType is optional, if you want full pagination controls.
  //     // Check dataTables documentation to learn more about
  //     // available options.
  // });
    $('#strain-datatable').dataTable({
        "processing": true,
        "serverSide": true,
        "ajax": {
            "url": $('#strain-datatable').data('source')
        },
        "pagingType": "full_numbers",
        "columns": [
            {"data": "cage_number"},
            {"data": "location"},
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
          title: {
            display:true,
            fontSize:15,
            fontColor:'#000',
            text:"Sex"
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
      var ageChart = new Chart(ctx2, {
        type: 'bar',
        data: {
          labels: ["0-4", "4-8", "8-12", "12-16", "16-20", "20+"],
          datasets: [{
            label: "Mice",
            data: data["numbers"],
            backgroundColor: [
              'rgba(128, 255, 0,0.6)',
              'rgba(0, 255, 128,0.6)',
              'rgba(0, 191, 255,0.6)',
              'rgba(0, 64, 255,0.6)',
              'rgba(191, 0, 255,0.6)',
              'rgba(255, 0, 64,0.6)'
            ],
            borderColor: [
              'rgba(128, 255, 0,1)',
              'rgba(0, 255, 128,1)',
              'rgba(0, 191, 255,1)',
              'rgba(0, 64, 255,1)',
              'rgba(191, 0, 255,1)',
              'rgba(255, 0, 64,1)'
            ]
          }]
        },
        options: {
          responsive:true,
          maintainAspectRatio:false,
          title: {
            display:true,
            fontSize:15,
            fontColor:'#000',
            text:"Age (months)"
          },
          legend:{
            display:false,
            position:'bottom',
            labels: {
              boxWidth:10
            }

          },
          scales: {}
        }
      }); /* close age chart instantiation */
    }); /* close AJAX call to graph_data_age endpoint */


  } /* close 'if (window.location.pathname === "/home/strain") {} block */
}); /* close 'on turbolinks:load' function */
/* clicking on the checkbox in the restore column of the removed mice table activates this function. First, the checkbox becomes disabled. Then specific values are taken from the table row. Finally an AJAX call
is made to the controller method, which will move a mouse back into its cage. */
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