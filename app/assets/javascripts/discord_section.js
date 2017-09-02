$(document).ready(function() {
  $('.discord-section').bind('inview', function (event, visible) {
       if (visible == true) {
         $(this).addClass('is-visible')
       }
     });

  var i = 0
  var features = [{
    title: 'Ça partage des sons',
    emoji: '🎧'
  },
  {
    title: 'Communauté 200% francophone', emoji: '🇫🇷'
  },
  {
    title: 'Que des fous', emoji: '🍾'
  },
  {
    title: 'Badge officiel de la mif', emoji: '📛'
  },
  {
    title: 'Des salons pour kicker',
    emoji: '🎤'
  },
  {
    emoji: '🔥',
    title: 'Du contenu exclusif'
  }
  ]

  setInterval(function() {
    if(features[i]) {
    } else {
      i = 0
    }

    $('.feature-emoji').text(features[i].emoji)
    $('.feature-title').text(features[i].title)

    i += 1
  }, 2000)
})
