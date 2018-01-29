$(document).on('turbolinks:load', function() {

  $('.grade-datepicker').datepicker({
    autoclose: true,
    todayHighlight: true,
    toggleActive: true,
    format: 'yyyy/mm/dd'
  });
});
