// 2. This code loads the IFrame Player API code asynchronously.
var tag = document.createElement('script');

tag.src = 'https://www.youtube.com/iframe_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 3. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
var player;
var playerState;
function onYouTubeIframeAPIReady() {
  player = new YT.Player('player', {
    width: '250',
    height: '180px',
    videoId: 'Pf06BWL7bJU',
    autoplay: true,
    events: {
      onReady: onPlayerReady,
      onStateChange: onPlayerStateChange
    }
  });
}

$('.button-player').on('click', function() {
  if (playerState.data == 2) {
    playVideo(player);
    player.seekTo(player.getDuration());
  } else {
    pauseVideo(player);
  }
});

function onPlayerReady(event) {
  event.target.playVideo();
}

function onPlayerStateChange(event) {
  playerState = event;
  if (event.data === 1) {
    // playing
    $('.button-player').attr('data-icon', 'pause');
    $(
      '.button-player, .button-provider, .badge-live, .volume-control-container'
    ).addClass('is-active');
    $('.badge-buffering').removeClass('is-active');
    player.unMute();
    player.setVolume(50);

    return false;
  } else if (event.data === 3) {
    // buffering
    $(
      '.button-player, .button-provider, .badge-live, .volume-control-container'
    ).removeClass('is-active');
    $('.badge-buffering').addClass('is-active');
  } else if (event.data == 2) {
    $('.button-player').attr('data-icon', 'play');
    // paused
  }
}
function stopVideo() {
  player.stopVideo();
}

$('.video-item-container').on('click', function() {
  pauseVideo(player);
});

function pauseVideo(player) {
  var currentVolume;
  if (player == null) {
    player = void 0;
  }
  if (!player) {
    throw new Error('No YouTube player instance specified.');
  }
  if (!player.hasOwnProperty('getVolume')) {
    throw new Error(
      "'" +
        Object.prototype.toString.call(player) +
        "' is not a valid YouTube player instance."
    );
  }
  currentVolume = player.getVolume();
  if (currentVolume === 0) {
    player.pauseVideo();
    player.unMute();
    return player.setVolume(50);
  } else {
    player.setVolume(currentVolume - 5);
    return setTimeout(function() {
      return pauseVideo(player);
    }, 10);
  }
}

function playVideo(player) {
  var currentVolume;
  if (player == null) {
    player = void 0;
  }
  if (!player) {
    throw new Error('No YouTube player instance specified.');
  }
  if (!player.hasOwnProperty('getVolume')) {
    throw new Error(
      "'" +
        Object.prototype.toString.call(player) +
        "' is not a valid YouTube player instance."
    );
  }

  player.playVideo();
  player.setVolume(0);

  currentVolume = player.getVolume();
  if (currentVolume === 50) {
    return player.setVolume(50);
  } else {
    player.setVolume(currentVolume + 5);
    return setTimeout(function() {
      return playVideo(player);
    }, 10);
  }
}

$(document).ready(function() {
  $('#volume').slider({
    min: 0,
    max: 100,
    orientation: 'horizontal',
    value: 50,
    range: 'min',
    slide: function(event, ui) {
      setVolume(ui.value);
    }
  });
});
function setVolume(val) {
  player.setVolume(val);

  if (val == 0) {
    $('.volume-control-container').attr('data-icon', 'mute');
  } else {
    $('.volume-control-container').attr('data-icon', 'full');
  }
}
