$(document).ready(function() {
  if ($('#register_form').size() > 0) {
    $('#register_submit').click(function() {
      $('#register_submit').attr('disabled', 'true');
      loading = newLoadingAnimation();
      $('#register_submit').empty().append(loading.canvas);
      loading.play();
      $('#register_form').submit();
    });
  }
});
