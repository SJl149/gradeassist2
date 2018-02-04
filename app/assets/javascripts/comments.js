$(document).on('turbolinks:load', function() {
  $('.comments-datepicker').datepicker({
     autoclose: true,
     orientation: "auto bottom",
     format: 'yyyy/mm/dd'
   });

})
