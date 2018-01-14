$(document).on('turbolinks:load', function() {
  $('.course-datepicker').datepicker({
     autoclose: true,
     daysOfWeekDisabled: [0,5],
     orientation: "auto bottom",
     format: 'yyyy/mm/dd'
   });
})
