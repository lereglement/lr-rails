# Le Reglement Rails

## Rails
Le site du reglement est une app Rails avec une base de donnee MySQL.  

### Setup
- Install [rbenv](https://github.com/rbenv/rbenv#installation)
- Install ruby 2.4.1 `rbenv install 2.4.1 && rbenv local 2.4.1`
- Install [Bundler](http://bundler.io/) `gem install bundler`
- Install MySQL `brew install mysql` and follow directive to have mysql launched at startup time
- `~/lr-rails $ bundle install`
- `~/lr-rails $ bundle exec rails db:create db:migrate`
- Download dump from clever-cloud staging db
- Import dump into your dev db `mysql -u user --password=password dev < <dump_file>`
- `bundle exec rails s` should successfully start :)


## Workflow
Tu devs sur une branche git (et non sur `master`) et testes en local sur ta branche.  

Une fois content, tu push ta branch (`git push origin <ta-branch>`) et ouvres une Pull Request (le gros bouton vert qui va apparaitre sur github).
On fait (peut-etre) une code review, et une fois bueno, tu peux merge ta branch sur master (autre gros bouton vert sur github).

T'inquietes paupiette - `master` n'est que tracked par le staging, qui va automatiquement deploy ton merge commit. Rien n'ira en prod, donc pas grave si tout pète, c'est staging, c'est fait pour ca (évites quand meme).  

Une fois que staging est en Y, tu peux merge `master` dans la branch `prod`. Pour ca, t'ouvres une PR (l'UI de github est chelou, c'est `prod <- master`). A l'envers ouesh.  

Une fois que tu merge la PR, l'app en production va automatiquement deploy la branch `prod`.

### Development urls
Si t'as setup l'app avec le repo Docker, ajoute dans `/etc/hosts`  

```
127.0.0.1       api.lereglement.here
127.0.0.1       data.lereglement.here
127.0.0.1       api-dev.lereglement.here
127.0.0.1       bo.lereglement.here
127.0.0.1       lereglement.here
127.0.0.1       staging.lereglement.here
127.0.0.1       obs.lereglement.here
```

Et t'aura accès a ces urls:  

```
    lereglement.here:3000     landing page
api.lereglement.here:3000     l'API
 bo.lereglement.here:3000     le back-office (active admin)
           127.0.0.1:3306     Acces a la DB (user/password dans le docker-compose.yml)
```

Et si t'es chaud du Docker, l'app run dans le container `web` et la db dans le container `db`.

## Hosting
On hoste tout sur clever-cloud.com. Meme chose que heroku.  
Max a les logins.  

`lr-rails-staging` c'est l'app staging et est connecté a la db `sql-staging` (logic).  
`lr-rails-prod` c'est l'app en prod (ATTENTION ✋) et la db c'est `sql-prod-S` (moins logique - `sql-prod` n'a pas l'air utilisée).  

### clever-tools
Clever Cloud offre une CLI `clever-tools` qui permet de faire a peu pres les memes choses qu'heroku.  

C'est [ICI](https://www.clever-cloud.com/doc/clever-tools/getting_started/) pour installer, et [ICI](https://console.clever-cloud.com/users/me/ssh-keys) pour ajouter ta clé ssh (tu devrai la trouver dans `~/.ssh/id_rsa.pub`.  

Une fois `clever-tools` installé, a partir du root du repo tu peux faire `clever link <app_id>` pour link l'app (soit staging soit prod) et `clever ssh` pour ssh dans l'app.  
`cd <app_id>` pour aller dans le folder de l'app rails. De là tu peux run `bundle exec <sketuveux>` genre `bundle exec rails console` et faire le fou.  

