$('#payment_form').ready(function() {
  $('#payment_form').submit(function(e) {
    $('input[type=submit]').attr('disabled', true);
    var circle = newLoadingAnimation();
    circle.play();
    $('.main').append(circle.canvas);
    
    var removeLoadingAnimation = function() {
      circle.stop();
      $('.main').remove('.sonic');
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
