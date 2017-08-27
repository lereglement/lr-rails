// 2. This code loads the IFrame Player API code asynchronously.
  var tag = document.createElement('script');

  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  // 3. This function creates an <iframe> (and YouTube player)
  //    after the API code downloads.
  var player;
  function onYouTubeIframeAPIReady() {
    player = new YT.Player('player', {
      width: '250',
      height: '141',
      videoId: 'A4tUSvPBDao',
      autoplay: true,
      events: {
        'onReady': onPlayerReady,
        'onStateChange': onPlayerStateChange
      }
    });
  }

  $('.button-player').on('click', function() {
    if(player.isMuted()) {
      player.unMute()
      $('.button-player').attr('data-icon', 'pause')
    } else {
      $('.button-player').attr('data-icon', 'play')
      player.mute()
    }
  })

  function onPlayerReady(event) {
    event.target.playVideo();
  }

  function onPlayerStateChange(event) {
    if(event.data === 1) {
      player.setVolume(100)
      $('.button-player, .button-provider, .badge-live').addClass('is-active')
      $('.badge-buffering').removeClass('is-active')
      return false
    } else {
      $('.button-player, .button-provider, .badge-live').removeClass('is-active')
      $('.badge-buffering').addClass('is-active')
    }

  }
  function stopVideo() {
    player.stopVideo();
  }
