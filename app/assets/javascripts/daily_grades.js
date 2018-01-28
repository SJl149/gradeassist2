$(document).on('turbolinks:load', function() {

  $('.grade-datepicker').datepicker({
    autoclose: true,
    daysOfWeekDisabled: [0,5,6],
    format: 'yyyy/mm/dd'
  }).on('changeDate', function() {
    $('.grade-time-select').submit();
  });
});
