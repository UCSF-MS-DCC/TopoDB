// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load',function() {
    $('#sandler-cages-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": $('#cages-datatable').data('source'),
        "data": {"location":"sandler"}
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "cage_number"},
        {"data": "strain"},
        {"data": "genotype"},
        {"data": "location"},
        {"data": "cage_type"}
      ]
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
    });
    $('#genentech-cages-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": $('#cages-datatable').data('source'),
        "data": {"location":"genentech hall"}
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "cage_number"},
        {"data": "strain"},
        {"data": "genotype"},
        {"data": "location"},
        {"data": "cage_type"}
      ]
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
    });
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
        ]
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
    
});
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