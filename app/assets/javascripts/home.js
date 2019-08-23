// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load',function() {
    $('#cages-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": $('#cages-datatable').data('source')
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "cage_number"},
        {"data": "strain"},
        {"data": "genotype"},
        {"data": "location"},
        {"data": "cage_type"},
        // {"data": "sex"},
        {"data": "contents"}
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
            {"data": "contents"}
        ]
        // pagingType is optional, if you want full pagination controls.
        // Check dataTables documentation to learn more about
        // available options.
    });
    /* Activating Best In Place */
    jQuery(".best_in_place").best_in_place();
    $('.highlight-on-success').bind("ajax:success", function (data) { if (!$(this).next("span").hasClass("hidden")) { $(this).next("span").addClass("hidden") }; $(this).prev("span").removeClass("hidden"); console.log(data) });
    $('.highlight-on-success').bind("ajax:error", function () { if (!$(this).prev("span").hasClass("hidden")) { $(this).prev("span").addClass("hidden") }; $(this).next("span").removeClass("hidden"); });

  });
