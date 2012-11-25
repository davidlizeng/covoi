$(document).ready(function() {

  if ($('#active_box').size() > 0) {
    $('#show_new').click(function(e) {
      $('#active_box').slideUp('slow', function() {
        $('#active_box').css('display', 'none');
        $('#trip_box').css('display', 'inline-block').hide().slideDown('slow');
      });
    });
  }

  if ($('#trip_box').size() > 0) {
    if ($('#show_active').size() > 0) {
      $('#show_active').click(function(e) {
        $('#trip_box').slideUp('slow', function() {
          $('#trip_box').css('display', 'none');
          $('#active_box').css('display', 'inline-block').hide().slideDown('slow');
        });
      });
    }
    $('#trip_date').datepicker({minDate: new Date(2012, 12 - 1, 1), maxDate: new Date(2012, 12 - 1, 15)});
  }

  if ($('#match_box').size() > 0) {
    $('#match_back_button').click(function(e) {
      clear_message('match_error');
      $('#match_box').slideUp('slow', function() {
        $('#match_box').css('display', 'none');
        $('#match_box_variable').empty();
        $('#trip_box').css('display', 'inline-block').hide().slideDown('slow');
      });
    });

    $('#match_next_button').click(function(e) {
      $('#match_next_button').attr('disabled', 'true');
      if ($('#trip_id:hidden').val() == '') {
        display_message('Please select a ride', 'error', 'match_error', 'match_next_button');
      } else {
        $('#match_next_button').removeAttr('disabled');
        clear_message('match_error');
        $('#match_box').slideUp('slow', function() {
          $('#match_box').css('display', 'none');
          $('#payment_box').css('display', 'inline-block').hide().slideDown('slow');
        });
      }
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

    $('#donate_20_button').click(function(e) {
      $('#donate_dollars').val('3');
      $('#donate_cents').val('00');
      $('#total_price').html('18.00');
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

    $('#payment_back_button').click(function(e) {
      clear_message('payment_error');
      $('#payment_box').slideUp('slow', function() {
        $('#payment_box').css('display', 'none');
        $('#match_box').css('display', 'inline-block').hide().slideDown('slow');
      });
    });

    $.ajaxSetup({
      'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "text/javascript");
      }
    });

    $('#payment_form').submit(function(e) {
      $('#payment_submit').attr('disabled', true);

      var stripeResponseHandler = function(status, response) {
        if (response.error){
          display_message(response.error.message, 'error', 'payment_error', 'payment_submit');
        } else {
          $('#trip_card_token').val(response['id']);
          $.ajax({
            url: '/matches',
            type: 'POST',
            data: $('#payment_form').serialize()
          });
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
  }

  if ($('#map_canvas').size() > 0) {
    var infoWindow = new google.maps.InfoWindow();
    var mapOptions = {
      center: new google.maps.LatLng(37.426782, -122.169322),
      zoom: 15,
      minZoom: 13,
      maxZoom: 19,
      streetViewControl: false,
      scrollwheel: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
    var allowedBounds = new google.maps.LatLngBounds(
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
      new google.maps.LatLng(37.424479, -122.16158),
      new google.maps.LatLng(37.425259, -122.165239),
      new google.maps.LatLng(37.423736, -122.170582),
      new google.maps.LatLng(37.425483, -122.174423),
      new google.maps.LatLng(37.426183, -122.179632)
    ];
    var markersTitles = [
      'Wilbur Lot',
      'Turnaround',
      'Tresidder',
      'Roble Gym',
      'Gov Co'
    ];
    var markersDescriptions = [
      '673 Escondido Rd',
      '618 Escondido Rd',
      '459 Lagunita Dr',
      '351 Santa Teresa St',
      '236 Santa Teresa St'
    ]
    var markersOptions = [];
    for (var i = 0; i < 5; ++i) {
      markersOptions.push({
        map: map,
        icon: new google.maps.MarkerImage(
          'https://chart.googleapis.com/chart?chst=d_bubble_text_small&chld=bb|'+ escape(markersTitles[i])+'|F4A342|000000',
          null, null, new google.maps.Point(0, 42)),
        position: markersPositions[i],
        title: markersDescriptions[i],
        zindex: 0
      });
      markers.push(new google.maps.Marker(markersOptions[i]));
    }
  }
});
