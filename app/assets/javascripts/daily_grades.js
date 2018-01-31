$(document).on('turbolinks:load', function() {

  $(".best_in_place").best_in_place();

  var start_date = ($('#start_end_dates').data('startDate'));
  var end_date = ($('#start_end_dates').data('endDate'));

  $('.grade-datepicker').datepicker({
    autoclose: true,
    startDate: start_date,
    endDate: end_date,
    format: 'yyyy/mm/dd'
  }).on('changeDate', function() {
    $('.grade-time-select').submit();
  });
});
