// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery3
//= require datatables
//= require best_in_place
//= require jquery-ui
//= require best_in_place.jquery-ui
//= require popper
//= require bootstrap-sprockets
//= require gritter
//= require Chart.min
//= require d3
//= require_tree .

$(document).on('turbolinks:load', function(){
    function boldMatchingSubstring(sub, str) {
        var subStartCharIdx = str.indexOf(sub);
        var subLen = sub.length;
        var subLastCharIdx = subStartCharIdx + subLen;
        //console.log(str,sub,subIdx);
        console.log(str,sub, str.substring(subStartCharIdx,subLastCharIdx));
        if (subLen >= str.length) {
            return "<strong><u>"+str+"</u></strong>"
        } else if (subStartCharIdx === 0) {
            return "<strong><u>"+str.substring(subStartCharIdx, subLastCharIdx)+"</u></strong>"+str.substring(subLastCharIdx)
        } else if (subStartCharIdx > 0 && subLastCharIdx < str.length) {
            return str.substring(0,subStartCharIdx)+"<strong><u>"+str.substring(subStartCharIdx, subLastCharIdx)+"</u></strong>"+str.substring(subLastCharIdx)
        } else if (subStartCharIdx > 0) {
            return str.substring(0,subStartCharIdx)+"<strong><u>"+str.substring(subStartCharIdx, subLastCharIdx)+"</u></strong>"
        } else {}
    }
    $('#navbar-search').on('keyup', function(e){
        $('.search-list-item').remove();
        if (e.target.value.length > 1) {
            $.ajax({
                beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
                type:"GET",
                url:"/home/search",
                data:{"cage_number":e.target.value},
                dataType:"json",
                success:function(data) {
                    if (data.length > 0) {
                        $('#search-results').css('display','inline-block');
                        data.forEach(function(element) {
                            boldMatchingSubstring(e.target.value,element[0])
                            $('#search-results-list').append('<li class="search-list-item"><a href="/home/cage?cage_number='+element[0]
                            +'&location='+element[1]+'&strain='+element[2]+'">'+element[1]+' > '+boldMatchingSubstring(e.target.value,element[0])+'</a></li>')
                        });
                    } else {
                        $('#search-results').css('display','none');
                    }
                }
            });
        }
    });
});