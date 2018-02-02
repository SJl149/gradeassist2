$(document).on('turbolinks:load', function() {

  var start_date = ($('#start_end_dates').data('startDate'));
  var end_date = ($('#start_end_dates').data('endDate'));
  var not_class_days = ($('#start_end_dates').data('notClassDays'));

  $('.welcome-datepicker').datepicker({
     autoclose: true,
     startDate: start_date,
     endDate: end_date,
     daysOfWeekDisabled: not_class_days,
     orientation: "auto bottom",
     format: 'yyyy/mm/dd'
   });

})
