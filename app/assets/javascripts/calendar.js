$('#trip_date').ready(function() {
  $('#trip_date').datepicker({minDate: +1, maxDate: new Date(2012, 12 - 1, 31)} );
});
