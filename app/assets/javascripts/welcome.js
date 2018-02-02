$(document).on('turbolinks:load', function() {
  $('.welcome-datepicker').datepicker({
     autoclose: true,
     orientation: "auto bottom",
     format: 'yyyy/mm/dd'
   });

})
