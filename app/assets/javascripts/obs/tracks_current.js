$(document).ready(function() {

  var interval = self.setInterval(function(){
      $.get(urlApi + "/v1/playlists/current", function( data ) {
        var track = data.data.title
        if (data.data.is_new) {
          track = track + '<img src="https://s3-eu-west-1.amazonaws.com/lereglement-prod/static/tags/new.png" class="tag">';
        }
        if (data.data.is_mif) {
          track = track + '<img src="https://s3-eu-west-1.amazonaws.com/lereglement-prod/static/tags/mif.png" class="tag">';
        }
        $( "#title" ).html( track );
        $( "#artist" ).html( data.data.artist );
      });
  }, 3000);


});
