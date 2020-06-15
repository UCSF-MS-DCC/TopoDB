$(document).on('turbolinks:load',function() {
    $('#mice-audit-table').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": $('#mice-audit-table').data('source')
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "id"},
        {"data": "cage"},
        {"data": "identifier"},
        {"data": "versions"},
        {"data": "last_update"},
        {"data": "last_event"},
        {"data": "who"}
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
    $('#cages-audit-table').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": {
        "url": $('#cage-audit-table').data('source')
      },
      "pagingType": "full_numbers",
      "columns": [
        {"data": "id"},
        {"data": "in_use"},
        {"data": "location"},
        {"data": "cage_number"},
        {"data": "transgenic_line"},
        {"data": "versions"},
        {"data": "last_update"},
        {"data": "last_event"},
        {"data": "who"}
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