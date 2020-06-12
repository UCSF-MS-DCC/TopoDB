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
  $('tr').each(function() {
    var values = $(this).children("td.score-cell").text().split("\n")
    values = values.filter(val => val.trim().length > 0).filter(val => !isNaN(val)).map(val => Number(val))
    if (values.length > 0) {
      console.log(values)
      $(this).children("td.mean-cell").text(mean(values).toFixed(6));
      $(this).children("td.se-cell").text((getSD(values)/Math.sqrt(values.length)).toFixed(6));
    }
  });
  $('.score-cell').on('submit', function(e){
    // get the values of all td.score-cells
    console.log($(this).text().split("\n")[2])
    console.log($(this))
    console.log($(this).closest('.score-cell').closest('tr').children("td.score-cell").text())
    var values = $(this).closest('.score-cell').closest('tr').children("td.score-cell").text().split("\n")
    //values.forEach(function(v) { console.log("the number is "+v.trim()+"! and is "+v.trim().length+" long")})
    values = values.filter(val => val.trim().length > 0).filter(val => !isNaN(val)).map(val => Number(val))
    console.log(values)
    console.log(mean(values))
    $(this).closest('.score-cell').closest('tr').children("td.mean-cell").text(mean(values).toFixed(6));
    $(this).closest('.score-cell').closest('tr').children("td.se-cell").text((getSD(values)/Math.sqrt(values.length)).toFixed(6))
    // run the mean and se calculations on all number value cells
    // write the results to the mean and se columns 

  })
});
function mean(numbers) {
  var total = 0, i;
  for (i = 0; i < numbers.length; i += 1) {
      total += numbers[i];
  }
  return total / numbers.length;
}
let getMean = function (data) {
  return data.reduce(function (a, b) {
      return Number(a) + Number(b);
  }) / data.length;
};

// Standard deviation
let getSD = function (data) {
    let m = getMean(data);
    return Math.sqrt(data.reduce(function (sq, n) {
            return sq + Math.pow(n - m, 2);
        }, 0) / (data.length - 1));
};
