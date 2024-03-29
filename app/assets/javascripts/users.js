$(document).ready(function() {

  if ($('#active_box').size() > 0) {
    $('#show_new').click(function(e) {
      $('#active_box').slideUp('slow', function() {
        $('#active_box').css('display', 'none');
        $('#trip_box').css('display', 'inline-block').hide().slideDown('slow');
      });
    });
  }

  if ($('#forms').size() > 0) {

    if ($('#show_active').size() > 0) {
      $('#show_active').click(function(e) {
        $('#trip_box').slideUp('slow', function() {
          $('#trip_box').css('display', 'none');
          $('#active_box').css('display', 'inline-block').hide().slideDown('slow');
        });
      });
    }
    var minDate = "+1d";
    var maxDate = "+1m"
    $('#trip_date').datepicker();
    $('#trip_date').datepicker("option","minDate",minDate);
    $('#trip_date').datepicker("option","maxDate",maxDate);

    $('#match_back_button').click(function(e) {
      //clear_message('match_error');
      $('#match_box').collapse('hide');
      $('#trip_box').collapse('show');
    });

    $('#payment_back_button').click(function(e) {
      //clear_message('payment_error');
      $('#payment_box').collapse('hide');
      $('#match_box').collapse('show');
    });

    $.ajaxSetup({
      'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "text/javascript");
      }
    });

    var stripeResponseHandler = function(status, response) {
      if (response.error) {
        display_message(response.error.message, 'error', 'payment_error', 'payment_submit');
        $('#payment_submit').empty().html('Finish');
      } else {
        $('#trip_card_token').val(response['id']);
        $.ajax({
          url: '/matches',
          type: 'POST',
          data: $('#payment_form').serialize()
        });
      }
    };

    $('#payment_submit').click(function(e) {
      $('#payment_submit').attr('disabled', true);
      loading = newLoadingAnimation();
      $('#payment_submit').empty().append(loading.canvas);
      loading.play();

      Stripe.createToken({
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        exp_month: $('#card_month').val(),
        exp_year: $('#card_year').val()
      }, stripeResponseHandler);

    });
  }

  if ($('#payment_box').size() > 0) {
    var dollars = 0;
    var cents = 0;

    $('#donate_10_button').click(function(e) {
      $('#donate_dollars').val('1');
      $('#donate_cents').val('50');
      $('#total_price').html('16.50');
    });

    $('#donate_15_button').click(function(e) {
      $('#donate_dollars').val('2');
      $('#donate_cents').val('25');
      $('#total_price').html('17.25');
    });

    $('#donate_20_button').click(function(e) {
      $('#donate_dollars').val('3');
      $('#donate_cents').val('00');
      $('#total_price').html('18.00');
    });

    $('#donate_150_button').click(function(e) {
      $('#donate_dollars').val('1');
      $('#donate_cents').val('50');
    });

    $('#donate_225_button').click(function(e) {
      $('#donate_dollars').val('2');
      $('#donate_cents').val('25');
    });

    $('#donate_300_button').click(function(e) {
      $('#donate_dollars').val('3');
      $('#donate_cents').val('00');
    });

    $('#donate_dollars').keypress(function(e) {
      var keyCode = window.event ? e.keyCode : e.which;
      if (keyCode < 48 || keyCode > 57) {
        if (keyCode != 0 && keyCode != 8 && keyCode != 13 && !e.ctrlKey) {
          e.preventDefault();
        }
      }
    });

    $('#donate_dollars').blur(function(e) {
      dollars = parseInt('15') + ((isNaN(parseInt($('#donate_dollars').val()))) ? 0 : Math.abs(parseInt($('#donate_dollars').val())));
      cents = (isNaN(parseInt($('#donate_cents').val()))) ? '0' : Math.abs(parseInt($('#donate_cents').val()));
      if (cents == 0) {
        $('#total_price').html(dollars.toString() + '.00');
      } else if (cents < 10) {
        $('#total_price').html(dollars.toString() + '.0' + cents.toString());
      } else if (cents < 100){
        $('#total_price').html(dollars.toString() + '.' + cents.toString());
      }
    });

    $('#donate_cents').keypress(function(e) {
      var keyCode = window.event ? e.keyCode : e.which;
      if (keyCode < 48 || keyCode > 57) {
        if (keyCode != 0 && keyCode != 8 && keyCode != 13 && !e.ctrlKey) {
            e.preventDefault();
        }
      }
    });

    $('#donate_cents').blur(function(e) {
      dollars = parseInt('15') + ((isNaN(parseInt($('#donate_dollars').val()))) ? 0 : Math.abs(parseInt($('#donate_dollars').val())));
      cents = (isNaN(parseInt($('#donate_cents').val()))) ? '0' : Math.abs(parseInt($('#donate_cents').val()));
      if (cents == 0) {
        $('#total_price').html(dollars.toString() + '.00');
      } else if (cents < 10) {
        $('#total_price').html(dollars.toString() + '.0' + cents.toString());
      } else if (cents < 100){
        $('#total_price').html(dollars.toString() + '.' + cents.toString());
      }
    });
  }

  if ($('#map_canvas_large').size() > 0) {
    var mapOptions = {
      center: new google.maps.LatLng(37.426782, -122.172322),
      mapTypeControl: false,
      zoom: 15,
      minZoom: 13,
      maxZoom: 19,
      streetViewControl: false,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas_large"), mapOptions);
    var allowedBounds = new google.maps.LatLngBounds(
      //TODO: expand bounds
      new google.maps.LatLng(37.419041,-122.184894),
      new google.maps.LatLng(37.4361,-122.156433)
    );
    var lastValidCenter = map.getCenter();

    google.maps.event.addListener(map, 'center_changed', function() {
      if (allowedBounds.contains(map.getCenter())) {
        lastValidCenter = map.getCenter();
        return;
      }
      map.panTo(lastValidCenter);
    });
    var markers = [];
    var markersPositions = [
      new google.maps.LatLng(37.425129, -122.164639),
      new google.maps.LatLng(37.423736, -122.170582),
      new google.maps.LatLng(37.426183, -122.179632)
    ];
    var markersTitles = [
      'Arrillaga Dining',
      'Tresidder Union',
      'Governor\'s Corner'
    ];
    var markersDescriptions = [
      '618 Escondido Rd',
      '459 Lagunita Dr',
      '236 Santa Teresa St'
    ];
    var markersWidths = [
      41, 47, 52
    ];
    var markersFiles = [
      'pin1', 'pin2', 'pin4'
    ];
    var markersOptions = [];

    var mapOptionsSmall = {
      center: new google.maps.LatLng(37.426782, -122.172322),
      mapTypeControl: false,
      zoom: 14,
      minZoom: 12,
      maxZoom: 18,
      streetViewControl: false,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var mapSmall = new google.maps.Map(document.getElementById("map_canvas_small"), mapOptionsSmall);
    var allowedBoundsSmall = new google.maps.LatLngBounds(
      //TODO: expand bounds
      new google.maps.LatLng(37.419041,-122.184894),
      new google.maps.LatLng(37.4361,-122.156433)
    );
    var lastValidCenterSmall = mapSmall.getCenter();

    google.maps.event.addListener(mapSmall, 'center_changed', function() {
      if (allowedBounds.contains(mapSmall.getCenter())) {
        lastValidCenterSmall = mapSmall.getCenter();
        return;
      }
      mapSmall.panTo(lastValidCenterSmall);
    });
    var markersSmall = [];
    var markersOptionsSmall = [];
    for (var i = 0; i < 3; ++i) {
      markersOptions.push({
        map: map,
        icon: new google.maps.MarkerImage(
          'https://covoi.herokuapp.com/images/' + markersFiles[i] + '.png',
          null, null, new google.maps.Point(markersWidths[i], 97)),
        position: markersPositions[i],
        title: markersDescriptions[i],
        zindex: 0
      });
      markersOptionsSmall.push({
        map: mapSmall,
        position: markersPositions[i],
        title: markersDescriptions[i],
        zindex: 0
      });
      markers.push(new google.maps.Marker(markersOptions[i]));
      markersSmall.push(new google.maps.Marker(markersOptionsSmall[i]));
    }
  }
});
