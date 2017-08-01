$(document).ready(function() {

  var interval = self.setInterval(function(){
      $.get(urlApi + "/v1/playlists/current", function( data ) {
        $( "#title" ).html( data.data.title );
        $( "#artist" ).html( data.data.artist );
      });
  }, 3000);


});
