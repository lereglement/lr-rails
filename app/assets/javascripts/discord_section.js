$(document).ready(function() {
  $('.discord-section').bind('inview', function (event, visible) {
       if (visible == true) {
         $(this).addClass('is-visible')
       }
     });

  var i = 0
  var features = [{
    title: 'Ça kick tous les soirs',
    emoji: '🎤'
  },
  {
    title: 'Partage d\'instrus', emoji: '📀'
  },
  {
    title: 'Auto-Géré par la mif', emoji: '🤝'
  },
  {
    title: 'En mode animal style',
    emoji: '🍟'
  },
  {
  title: 'La mif en Y', emoji: '✌️'
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
