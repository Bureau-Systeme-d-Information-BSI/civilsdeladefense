# Civilsdeladefense

Application de gestion de recrutements.

## Environnement de développement

Application Ruby on Rails avec base de données PostgreSQL, assets compilés avec webpack, suite de tests avec RSpec.

Des fichiers de définition Docker docker-compose sont présents pour faciliter la mise en place de l'environnements de développement.

Build des images Docker :

```
docker-compose build
```

Installation des gems :

```
docker-compose run web bundle install

Cette commande doit être lancée dès qu'une nouvelle gem apparait.
```

Installation des packages Javascript :

```
docker-compose run web yarn install
```

Un fichier .env à la racine du projet local au développeur derait contenir les valeurs suivantes :

```
DEFAULT_FROM=hello@localhost
DEFAULT_HOST=http://localhost:3000
```

Optionnellement ce fichier .env peut contenir les variables suivantes pour configurer un Object Storage basé sur OSU/S3 :

```
OSC_AK=XXX
OSC_SK=YYY
OSC_BUCKET=ZZZ
OSC_REGION=eu-west-2
OSC_ENDPOINT=https://osu.eu-west-2.outscale.com
```

Créer le fichier config/master.key contenat la clé principale : le contenu du fichier doit être demandée à l'équipe de développement.

Créer la base de données avec les données de seed :

```
docker-compose run web rails db:drop db:create db:schema:load db:seed
```

Lancement d'une migration de base :

```
docker-compose run web rails db:migrate
```

Démarrage des images :

```
docker-compose down && docker-compose up
```

## Workflow de développement

Le workflow de développement est basé sur le [GitHub flow](https://guides.github.com/introduction/flow/) :

- chaque changement de code (nouvelle fonctionnialité, bug fix, etc) devrait résulter d'un ticket (une _issue_ GitHub)
- chaque changement de code devrait passer une _review_ de code via une Pull Request

La bonne manière de créer une Pull Request est de :

- créer localement une nouvelle branche correspondant au ticket/issue qu'on veut traiter via `git checkout master && git pull && git checkout -b fix/13`
- modifier le code et accumuler les commits dans cette nouvelle branch. Les commits devraient mentionner le ticket correspondant (utiliser les mot-clés _fix_ or _see_)
- pousser le code vers GitHub `git push origin fix/13`
- ouvrir une PUll Request
- attendre la review de code et éventuellement modifier son code en fonction des commentaires

## Lancer les tests

Pour lancer les test RSpec :

```
docker-compose run specs rspec
```

Pour lancer l'outil d'analyse statique de formatage Rubocop :

```
docker-compose run web bundle exec rubocop
```

Pour lancer l'outil d'analyse statique de vulnérabilités Brakeman :

```
docker-compose run web bundle exec brakeman -z
```

One-liner :

```
 docker-compose run specs rspec && docker-compose run web bundle exec rubocop && docker-compose run web bundle exec brakeman -z
```

## Déploiement en préproduction

Actuellement, la branche master est autodéployée sur Scalingo.

## Déploiement en production

Actuellement, la branche production est autodéployée sur Scalingo.

### Premier déploiement

Avant de déployer le code, il faut définir la variable d'environnement `DO_NOT_POSTDEPLOY` avec la valeur `1`. Ceci a pour effet de ne pas lancer automatiquement la tâche `db:migrate` dans la phase `postdeploy`. Il faudra supprimer la variable d'environnement après un premier déploiement en `success`.

Lancer le déploiement puis charger le schéma de données :

```
rails db:schema:load
```

Supprimer la variable d'environnement `DO_NOT_POSTDEPLOY`.

```ruby
organization = Organization.create!(
  brand_name: "Ministère des Armées",
  domain: "domain.tld",
  prefix_article: "le",
  service_description: "Plateforme de recrutement de personnel civil contractuel du ministère des Armées",
  service_description_short: "Plateforme de recrutement de personnel civil contractuel",
  service_name: "Civils de la Défense ",
  subdomain: "cvd-staging"
)
```

Créer le premier compte admin :

```ruby
admin = Administrator.new(
  email: 'prenom.nom@domaine.com',
  first_name: 'Prénom',
  last_name: 'Nom',
  password: '???',
  very_first_account: true,
  role: 'bant',
  organization: organization
)
admin.skip_confirmation_notification!
admin.save!
admin.confirm
``` 

## Services externes

Envoie de mail SMTP
Configuration par la variable d'environnement SMTP_URL :
`SMTP_URL=smtp://username_url_encoded:password@host:port`

Récupération mail IMAP
Configuration par la variable d'environnement MAIL_URL :
`MAIL_URL=imaps://username_url_encoded:password@host:port`
Le protocole spécifié dans la chaîne de connexion sera ignoré et remplacé par imap (avec TLS), de même pour le port qui sera remplacé par 993.

Transfert des emails dans la corbeille après traitement
Configuration par la variable d'environnement MAIL_FOLDER_TRASH :
`MAIL_FOLDER_TRASH=Trash`
