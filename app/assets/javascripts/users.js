$('#register_form').ready(function() {
  var circle = newLoadingAnimation();
  var beforeHandler = function() {
    circle.play();
    $('.main').append(circle.canvas);
    $('#message_banner').empty();
  };
  var successHandler = function() {
    circle.stop();
    $('.sonic').remove();
  };  
  $('#register_form').bind('ajax:before', beforeHandler);
  $('#register_form').bind('ajax:success', successHandler);
});
