$(document).on('turbolinks:load', function(){
    /* Activating Best In Place */
    jQuery(".best_in_place").best_in_place();

    /* Show/hide the green check and red x in each editable cell in the best-in-place enabled table depending on the outcome of the AJAX call */
    $('.highlight-on-success').bind("ajax:success", function (e) { 
        if (!$(this).next("span").hasClass("hidden")) {
            $(this).next("span").addClass("hidden") 
        };
        $(this).prev("span").removeClass("hidden"); 
    });
    $('.highlight-on-success').bind("ajax:error", function () { if (!$(this).prev("span").hasClass("hidden")) { $(this).prev("span").addClass("hidden") }; $(this).next("span").removeClass("hidden"); });

    /* In breeding cage views, color code the rows that aren't pups (ie parents) */
    $('.cage-parent-row').css("background-color","greenyellow");

    /* Datepicker jquery initialization code here */
    //$('#pups_birthdate').datepicker();
    $('#new_mouse_birthdate').datepicker();
    $.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd'
    });

    /* In mouse remove modal, disable the experiment select element if there are no target experiments available */
    if ($('.experiment-targets').length < 1) {
      $('#modal-mouse-remove-experiment').prop("disabled", true);
    } 

    /* This code transfers mouse data to the remove mouse modal and handles to AJAX call to the contoller */
    $('.modal').on('show.bs.modal', function(e) {
        if ($(e.relatedTarget).data("dependencies")) {
          var parsed = $(e.relatedTarget).data("dependencies");
          var mouseIdx = parsed["mouseid"];
          var cageID = parsed["cage_id"];
          var mouseData;
        
          /* This AJAX call pings the mouse show controller method for the most up-to-date state of the mouse to populate modal fields. */
          $.ajax({
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            type:"GET",
            url:"/home/mouse",
            data:{"mouse":mouseIdx},
            dataType:"json",
            success:function(reply) {
              mouseData = reply["data"];
              $('#modal-mouse-remove-date').datepicker().datepicker("setDate", new Date());
              $('#modal-mouse-designation').text(mouseData["three_digit_code"]);
              $('#modal-mouse-sex').text(["N/A","F", "M"][mouseData["sex"]]);
              $('#modal-mouse-cage-number').text(parsed["mousecage"]);
              $('#modal-mouse-earpunch').text(["-","N","R","L","RR","RL","LL","RRL","RLL","RRLL"][mouseData["ear_punch"]-1]);
              $('#modal-mouse-strain').text(mouseData["strain"]+":");
              $('#modal-mouse-genotype').text(["","N/A","+/+","+/-","-/-"][mouseData["genotype"]]);
              $('#modal-mouse-dob').text(mouseData["dob"]);
              if (mouseData["strain2"] != null) {
                $('#second-strain-modal-row').css("display", "flex");
                $('#modal-mouse-strain2').text(mouseData["strain2"]+":");
                $('#modal-mouse-genotype2').text(["","N/A","+/+","+/-","-/-"][mouseData["genotype2"]]);
              }
            },
              error:function(jqxhr,reply,status) { alert("Mouse data was not fetched, please notify a site administrator."); }
          }); /* close AJAX call to get current mouse state data */
          //AJAX call to mouse#update method
          $('#destroyMouseConfirm').on('click', function(){
            var rDate = $('#modal-mouse-remove-date').val();
            var rReason = $('#modal-mouse-remove-reason').val();
            var rExperiment = $('#modal-mouse-remove-experiment').val()
    
            $.ajax({
              beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
              type:"PUT",
              url:"/cage/"+cageID+"/mouse/"+mouseIdx,
              data:{"new_col_value":{"removed":rDate, "removed_for":rReason, "experiment_id":rExperiment}},
              dataType:"json",
              success:function(reply) { window.location.reload(); },
              error:function(jqxhr,reply,status) { alert("Mouse was not removed, please notify a site administrator."); }
            })
          })
        }
      });
}); /* close document on turbolinks:load block */