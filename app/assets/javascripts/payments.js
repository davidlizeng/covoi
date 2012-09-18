/** Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
*/
$(document).ready(function() {
  $('#payment_form').submit(function(e) {
    $('input[type=submit]').attr('disabled', true);
    
    var circle = new Sonic({
      width: 50,
      height: 50,
      padding: 0,
      strokeColor: '#000000',
      pointDistance: .01,
      stepsPerFrame: 3,
      trailLength: .7,
      step: 'fader',
      setup: function() {
        this._.lineWidth = 5;
      },
      path: [
          ['arc', 25, 25, 25, 0, 360]
      ]
    });
    circle.play();
    $('.main').append(circle.canvas);
    
    var removeLoadingAnimation = function() {
      circle.stop();
      $('.main').remove('canvas');
    }    

    var stripeResponseHandler = function(status, response) {
      if (response.error){
        alert(response.error.message);
        removeLoadingAnimation();
        $('input[type=submit]').removeAttr('disabled');
      } else {
        $('#trip_card_token').val(response['id']);
        $('#payment_form').submit();
      }
    };
    Stripe.createToken({
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      exp_month: $('#card_month').val(),
      exp_year: $('#card_year').val()
    }, stripeResponseHandler);
    
    return false;
  });
});
