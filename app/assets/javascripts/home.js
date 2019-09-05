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
          {"data": "genotype"},
          {"data": "removed"},
          {"data": "removed_for"},
          {"data": "restore"}
      ],
      "initComplete": function(settings, json) {
        $('tr td:nth-child(7)').each(function(idx) {
          $(this).append('<input type="checkbox" onChange="restoreMouse(this)">')
        })
      }
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
  });
    /* Activating Best In Place */
    jQuery(".best_in_place").best_in_place();
    $('.highlight-on-success').bind("ajax:success", function (data) { if (!$(this).next("span").hasClass("hidden")) { $(this).next("span").addClass("hidden") }; $(this).prev("span").removeClass("hidden"); });
    $('.highlight-on-success').bind("ajax:error", function () { if (!$(this).prev("span").hasClass("hidden")) { $(this).prev("span").addClass("hidden") }; $(this).next("span").removeClass("hidden"); });
    
});
function restoreMouse(obj) {
  if (obj.checked === true) {
    $(obj).prop("disabled", true); 
    var mouseID = $(obj).parent().parent().children('td').eq(1).html();
    var cageNumber = $(obj).parent().parent().children('td').eq(0).html();
    var strain = $(obj).parent().parent().children('td').eq(2).html();
    var removedDate = $(obj).parent().parent().children('td').eq(4).html()
    $.ajax({
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      type:"POST",
      url:"/home/restore_mouse",
      data:{"mouse":mouseID, "cage":cageNumber, "strain":strain, "removed":removedDate},
      dataType:"json",
      success:function(reply) { alert(JSON.stringify(reply.message)); },
      error:function(reply) { alert(JSON.stringify(reply.message)); }
    })
  }
  
}