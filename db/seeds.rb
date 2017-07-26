# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create!(email: 'kevin@getbonnie.com', password: 'PQHtfEd%a4mFEBb(hG', password_confirmation: 'PQHtfEd%a4mFEBb(hG')
AdminUser.create!(email: 'olivier@getbonnie.com', password: 'CW7hVej[BmFwMak.dp!', password_confirmation: 'CW7hVej[BmFwMak.dp!')
AdminUser.create!(email: 'fred@getbonnie.com', password: 'M)P7rwoJ)QpnsEvxnW!', password_confirmation: 'M)P7rwoJ)QpnsEvxnW!')
AdminUser.create!(email: 'yspychala@gmail.com', password: 'M-32DsssQpnsEvxnW', password_confirmation: 'M-32DsssQpnsEvxnW')
Copywriting.create({
  ref: :WELCOME,
  content: "Bienvenue sur Bonnie !

Nous sommes super heureux de te compter parmi nos membres. Moi, c’est Olivier enchanté 🙂 Tu peux m’écrire ici, je suis là pour répondre à tes questions, discuter ou tout autre demande.

Sache qu’à ce jour, Bonnie est exclusivement disponible sur Paris. Mais si tu es loin, pas d’inquiétude, ce n’est qu’une question de temps...

C’est le moment de se lancer : je te laisse découvrir les membres et faire ton choix en aimant tes cards préférées.
Bonnes rencontres 💚"
})
