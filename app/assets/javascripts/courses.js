$(document).on('turbolinks:load', function() {
  $('.course-datepicker').datepicker({
     autoclose: true,
     orientation: "auto bottom",
     format: 'yyyy/mm/dd'
   });

   $("#class_days a.add_fields").
   data("association-insertion-position", 'before').
   data("association-insertion-node", 'this');

   $("#holidays a.add_fields").
   data("association-insertion-position", 'before').
   data("association-insertion-node", 'this');

   $("#categories a.add_fields").
   data("association-insertion-position", 'before').
   data("association-insertion-node", 'this');
})
