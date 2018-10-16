$(function(){
  $('.js-length-limit-warning').each(function(){
    var field_selector = $(this).data('target-field');
    var max_length = $(this).data('max-length');
    var warning_90pct = $(this).find('.js-length-90pct');
    var warning_exceeded = $(this).find('.js-length-exceeded');
    console.log('Registering length warnings for field '+field_selector+'.');

    $(field_selector).keyup(function(e){
      var current_length = $(field_selector).val().length;
      console.log('Detected keypress for field '+field_selector+'.');
      if (current_length > max_length) {
        warning_90pct.hide();
        warning_exceeded.show();
      } else if (current_length >= max_length * 0.9) {
        warning_90pct.show();
        warning_exceeded.hide();
      } else {
        warning_90pct.hide();
        warning_exceeded.hide();
      }
    });
  });
});