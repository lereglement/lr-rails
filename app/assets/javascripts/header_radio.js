$(document).ready(function() {
  var old_track = {}
  var track = {}
  setInterval(function() {
    $.get('http://cache.lereglement.sale/current', function(response) {
      track = response.data;
      if(track.title != $('.header-radio-title').text() ) {
        $('.cover-huge, .cover-shadow').css({backgroundImage: "url(" + track.cover_large + ")"})
        $('.header-radio-title').text(track.title)
        $('.header-radio-subtitle').html('<span>de</span>  ' + track.artist)

        if (!document.hasFocus()) {
          document.title = track.title + " - " + track.artist + " sur Le Règlement"
        }

        if(track.external_source) {
          $('.button-provider').removeClass('is-hidden button-soundcloud button-youtube')
          $('.button-provider').addClass('button-' + track.origin_external_source)
          $('.button-provider').attr('href', track.external_source)
        } else { $('.button-provider').addClass('is-hidden') }

        if(old_track.title != $('.track-item').last().find('.track-item-title').text()) {
          $('.track-item').first().remove()
          $('.previous-tracks').append("<div class='track-item'><div class='track-item-cover' style='background-image: url( " + old_track.cover_xsmall + ")'></div><div><div class='track-item-title'>" + old_track.title + "</div><div class='track-item-artist'>" + old_track.artist + "</div><div></div>")
        }

      } else {
        old_track = track
      }
    })
  }, 1000)

  $(window).focus(function() {
    document.title = "Le Règlement"
  });

  $(window).blur(function() {
    document.title = track.title + " - " + track.artist + " sur Le Règlement"
  });
})


