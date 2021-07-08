# E-Recrutement

Application de gestion de recrutements.

Application Ruby on Rails avec base de données PostgreSQL, assets compilés via webpack et suite de tests utilisant RSpec.

## Pour commencer

Ces instructions vous permettront de mettre en place une copie du projet sur votre machine locale à des fins de développement et de test. Voir Déploiement pour des notes sur la façon de déployer le projet sur un système réel.

### Prérequis

- Docker

ou

- PostgreSQL
- Ruby
- Yarn

### Installation

Des fichiers de définition docker-compose sont présents pour faciliter la mise en place de l'environnements de développement (voir paragraphe Gestion avec Docker Compose).

Installation des dépendances

```
bundle install
yarn install
```

Créer un fichier .env à la racine du projet contenant les valeurs

```
DEFAULT_FROM=hello@localhost
DEFAULT_HOST=http://localhost:3000
LOCKBOX_MASTER_KEY=
```

Optionnellement ce fichier .env peut contenir les variables suivantes pour configurer un Object Storage basé sur OSU/S3

```
OSC_AK=access_key
OSC_SK=secret_key
OSC_BUCKET=bucket_name
OSC_REGION=eu-west-2
OSC_ENDPOINT=https://osu.eu-west-2.outscale.com
```

Créer la base de données avec les données de seed

```
rails db:drop db:create db:schema:load db:seed
```

### Gestion avec Docker Compose

Toutes les commandes cités peuvent être lancé via Docker Compose

```
docker-compose run web *command*
```

Build des images Docker

```
docker-compose build
```

Démarrage des images

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
- ouvrir une Pull Request
- attendre la review de code et éventuellement modifier son code en fonction des commentaires

## Lancer les tests

Pour lancer les test RSpec

```
bundle exec rspec
```

Pour lancer l'outil d'analyse statique de formatage Rubocop

```
bundle exec rubocop
```

Pour lancer l'outil d'analyse statique de vulnérabilités Brakeman

```
bundle exec brakeman
```

## Déploiement en préproduction et production

Les branches master et production sont autodéployées grâce à Scalingo.

## Premier déploiement

### Génération de la base de données

Avant de déployer le code, il faut définir la variable d'environnement `DO_NOT_POSTDEPLOY=1`. Ceci a pour effet de ne pas lancer automatiquement la tâche `db:migrate` dans la phase `postdeploy`. Il faudra supprimer la variable d'environnement après un premier déploiement en `success`.

Lancer le déploiement puis charger le schéma de données

```
rails db:schema:load
```

Supprimer la variable d'environnement `DO_NOT_POSTDEPLOY`.

### Création des données initiales

Créer la première organisation

```ruby
organization = Organization.create!(
  brand_name: "Ministère des Armées",
  domain: "domain.tld",
  prefix_article: "le",
  service_description: "Plateforme de recrutement de personnel civil contractuel du ministère des Armées",
  service_description_short: "Plateforme de recrutement de personnel civil contractuel",
  service_name: "Civils de la Défense "
)
```

Créer le premier compte admin

```ruby
admin = Administrator.new(
  email: 'prenom.nom@domaine.com',
  first_name: 'Prénom',
  last_name: 'Nom',
  password: '8 caractères minimum (1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spécial)',
  very_first_account: true,
  role: 'bant', # superadmin
  organization: organization
)
admin.skip_confirmation_notification!
admin.save!
admin.confirm
```

### Services externes

- Envoie de mail SMTP `SMTP_URL=smtp://username_url_encoded:password@host:port`
- Récupération mail IMAP `MAIL_URL=imaps://username_url_encoded:password@host:port`
- Transfert des emails après traitement `MAIL_FOLDER_TRASH=Trash` et `MAIL_FOLDER_ARCHIVE=Archive`
