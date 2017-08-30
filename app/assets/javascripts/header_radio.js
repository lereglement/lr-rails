$(document).ready(function() {
  var old_track = {}
  setInterval(function() {
    $.get('http://data.lereglement.sale/v1/playlists/current', function(response) {
      var track = response.data;
      if(track.title != $('.header-radio-title').text()) {
        $('.cover-huge, .cover-shadow').css({backgroundImage: "url(" + track.cover_large + ")"})
        $('.header-radio-title').text(track.title)
        $('.header-radio-subtitle').html('<span>de</span>  ' + track.artist)
        $('.track-item').first().remove()
        $('.previous-tracks').append("<div class='track-item'><div class='track-item-cover' style='background-image: url( " + old_track.cover_xsmall + ")'></div><div><div class='track-item-title'>" + old_track.title + "</div><div class='track-item-artist'>" + old_track.artist + "</div><div></div>")

      } else {
        old_track = track
      }
    })
  }, 1000)
})
