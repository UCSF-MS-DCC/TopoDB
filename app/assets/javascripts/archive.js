$(document).on('turbolinks:load',function() {
    $('#archives-datatable').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": $('#archive-datatable').data('source')
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "date"},
        {"data": "time"},
        {"data": "user"},
        {"data": "description"}
      ],
      "language": {
        "paginate": {
          "previous": "<<-",
          "next": "->>",
          "first":"Newest",
          "last":"Oldest"
        }
      }
      // pagingType is optional, if you want full pagination controls.
      // Check dataTables documentation to learn more about
      // available options.
    });

});