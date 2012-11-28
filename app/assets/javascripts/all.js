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

var newLoadingAnimation = function() {
  var circle = new Sonic({
    width: 20,
    height: 20,
    padding: 3,
    strokeColor: '#ffffff',
    pointDistance: .01,
    stepsPerFrame: 3,
    trailLength: .7,
    step: 'fader',
    setup: function() {
      this._.lineWidth = 3;
    },
    path: [
        ['arc', 10, 10, 10, 0, 360]
    ]
  });
  return circle;
};

$(document).ready(function() {
  if ($(window).height() > $('#main').height() + $('#header').height() + $('#footer').height() + 2) {
    $('#main').css('min-height', ($(window).height() - $('#header').height() - $('#footer').height() - 2).toString() + 'px');
  }
  $(window).resize(function () {
    if ($(window).height() > $('#main').height() + $('#header').height() + $('#footer').height() + 2) {
      $('#main').css('min-height', ($(window).height() - $('#header').height() - $('#footer').height() - 2).toString() + 'px');
    }
  });
});
