$(document).ready(function() {
  setInterval(function() {
    $.get('http://data.lereglement.sale/v1/playlists/current', function(response) {
      var track = response.data;
      if(track.title != $('.header-radio-title').text()) {
        $('.cover-huge, .cover-shadow').css({backgroundImage: "url(" + track.cover_large + ")"})
        $('.header-radio-title').text(track.title)
        $('.header-radio-subtitle').html('<span>de</span>  ' + track.artist)
      }
    })
  }, 1000)
})
