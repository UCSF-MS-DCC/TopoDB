$(document).on('turbolinks:load', function(){
  $('#experiment-datatable').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": {
      "url": $('#users-datatable').data('source')
    },
    "pagingType": "full_numbers",
    "columns": [
      {"data": "date"},
      {"data": "name"},
      {"data": "gene"},
      {"data": "description"},
      {"data": "id"}
    ],
    "columnDefs": [
      {
        "targets": [4],
        "render" : function(data, type, row) {
          return "<a class='btn btn-primary btn-sm' href='/experiment/"+row["id"]+"'>Show</a>"
        }
      }
    ]
    // pagingType is optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about
    // available options.
  });
  $('.score-cell').on('submit', function(e){
    // console.log($(e.currentTarget.closest('tr').cells));
    var row = $(e.currentTarget.closest('tr').id);
    console.log(row);

  })
});
