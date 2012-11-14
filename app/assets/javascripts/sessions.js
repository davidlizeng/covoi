$(document).ready(function() {
  if ($('#register_form').size() > 0) {
    var beforeHandler = function() {
      $('#register_submit').attr('disabled', 'true');
    };
    var successHandler = function() {
    };
    $('#register_form').bind('ajax:before', beforeHandler);
    $('#register_form').bind('ajax:success', successHandler);
  }
});

var display_message = function(message, type, containerId, elementId) {
  var messageClass = (type == 'error') ? 'error' : 'notice'
  var htmlString = '<div class="' + messageClass + '">' + $('<div/>').text(message).html() + '</div>';
  var element = $('#' + elementId);
  var container = $('#' + containerId);
  if (container.children().length > 0) {
    container.slideUp('slow', function() {
      container.empty().append(htmlString).slideDown('slow');
      element.removeAttr('disabled');
    });
  } else {
    container.append(htmlString).hide().slideDown('slow');
    element.removeAttr('disabled');
  }
};

var clear_message = function(containerId) {
  var container = $('#' + containerId);
  container.slideUp('slow', function() {
    container.empty();
  });
};
