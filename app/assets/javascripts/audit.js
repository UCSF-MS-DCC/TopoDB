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
    // $('#mouse-version-datatable').dataTable({
    //   "processing": true,
    //   "serverSide": true,
    //   "ajax": {
    //     "url": $('#mouse-version-datatable').data('source')
    //   },
    //   "pagingType": "full_numbers",
    //   "columns": [
    //     {"data": "version"},
    //     {"data": "sex"},
    //     {"data": "mouse_id"},
    //     {"data": "ear_punch"},
    //     {"data": "t_line"},
    //     {"data": "genotype"},
    //     {"data": "cage"},
    //     {"data": "experiment"},
    //     {"data": "who"}
    //   ],
    //   "language": {
    //     "paginate": {
    //       "previous": "<<-",
    //       "next": "->>",
    //       "first":"Newest",
    //       "last":"Oldest"
    //     }
    //   }
    //   // pagingType is optional, if you want full pagination controls.
    //   // Check dataTables documentation to learn more about
    //   // available options.
    // });
});