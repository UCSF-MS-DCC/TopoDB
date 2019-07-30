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
        {"data": "cage_type"},
        {"data": "sex"},
        {"data": "expected_weaning_date"}
      ]
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
    });
console.log(window.location.href.split("=")[1])
    // $('#single-cage-datatable').dataTable({
    //     "processing": true,
    //     "serverSide": true,
    //     "ajax": {
    //       "url": $('#single-cage-datatable').data('source')+"&cage_number="+"BLAH"
    //     },
    //     "pagingType": "full_numbers",
    //     "columns": [
    //       {"data": "genotype"},
    //       {"data": "ID"},
    //       {"data": "birth cage"},
    //       {"data": "wean date"}
    //     ]
    //     // pagingType is optional, if you want full pagination controls.
    //     // Check dataTables documentation to learn more about
    //     // available options.
    //   });
  });