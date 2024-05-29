# e-recrutement

Application de gestion de recrutements.

Application Ruby on Rails avec base de données PostgreSQL, assets compilés via esbuild et suite de tests utilisant RSpec.

## Prérequis

- PostgreSQL
- Ruby 3.3.0
- Node 18
- Yarn
- Redis
- ImageMagick

## Installation locale

Installation des dépendances

```
bundle install
yarn install
```

Créer un fichier .env à la racine du projet contenant les valeurs :

```
DEFAULT_FROM=hello@localhost
DEFAULT_HOST=http://localhost:3000
LOCKBOX_MASTER_KEY=
```

Optionnellement ce fichier .env peut contenir les variables suivantes pour configurer un Object Storage basé sur OSU/S3 :

```
OSC_AK=access_key
OSC_SK=secret_key
OSC_BUCKET=bucket_name
OSC_REGION=eu-west-2
OSC_ENDPOINT=https://osu.eu-west-2.outscale.com
```

Créer la base de données avec les données de seed :

```
bin/rails db:drop db:create db:schema:load db:seed
```

Pour démarrer l'application localement :

```
bin/dev
```

## Workflow de développement

Le workflow de développement est basé sur le [GitHub flow](https://guides.github.com/introduction/flow/) :

- chaque changement de code (nouvelle fonctionnalité, bug fix, etc) devrait résulter d'un ticket (une _issue_ GitHub)
- chaque changement de code devrait passer une _review_ de code via une Pull Request

La bonne manière de créer une Pull Request est de :

- créer localement une nouvelle branche correspondant au ticket/issue qu'on veut traiter via `git checkout master && git pull && git checkout -b fix/13`
- modifier le code et accumuler les commits dans cette nouvelle branch. Les commits devraient mentionner le ticket correspondant (utiliser les mot-clés _fix_ or _see_)
- pousser le code vers GitHub `git push origin fix/13`
- ouvrir une Pull Request
- attendre la review de code et éventuellement modifier son code en fonction des commentaires

## Tests

Pour lancer les test RSpec :

```
bundle exec rspec
```

## Style de code

Pour lancer l'outil d'analyse statique de formatage Rubocop :

```
bundle exec rubocop
```

## Sécurité

Pour lancer l'outil d'analyse statique de vulnérabilités Brakeman :

```
bundle exec brakeman
```

## Jobs asynchrones

Pour exécuter les jobs asynchrones :

```
bundle exec sidekiq
```

## Déploiement en préproduction et production

Les branches master et production sont déployées automatiquement grâce à Scalingo.
- master correspond aux applications de staging
- production correspond aux application de production

Pour chaque Pull Request créée, une application de review est automatiquement démarrée par Scalingo.

## Premier déploiement

### Génération de la base de données

Avant de déployer le code, il faut définir la variable d'environnement `DO_NOT_POSTDEPLOY=1`.
Ceci a pour effet de ne pas lancer automatiquement la tâche `db:migrate` dans la phase `postdeploy`.
Il faudra supprimer la variable d'environnement après un premier déploiement en `success`.

Lancer le déploiement puis charger le schéma de données :

```
bin/rails db:schema:load
```

Supprimer la variable d'environnement `DO_NOT_POSTDEPLOY`.

### Création des données initiales

Créer la première organisation

```ruby
organization = Organization.create!(
  brand_name: "...",
  service_name: "...",
  prefix_article: "..."
)
```

Créer le premier compte admin

```ruby
admin = Administrator.new(
  email: 'prenom.nom@domaine.com',
  first_name: 'Prénom',
  last_name: 'Nom',
  password: '12 caractères minimum (1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spécial)',
  very_first_account: true,
  role: 'admin',
  organization: organization
)
admin.skip_confirmation_notification!
admin.save!
admin.confirm
```

## Services externes

- Envoi de mail SMTP `SMTP_URL=smtp://username_url_encoded:password@host:port`
- Récupération de mail IMAP `MAIL_URL=imaps://username_url_encoded:password@host:port`
- Transfert des emails après traitement `MAIL_FOLDER_TRASH=Trash` et `MAIL_FOLDER_ARCHIVE=Archive`


## Problèmes divers

### charlock_holmes

Quand `icu4c` est mis à jour (par exemple suite à un `brew upgrade`), la gem `charlock_holmes` doit être ré-installé en utilisant la commande `bundle pristine charlock_holmes`.

Erreur visible quand il est nécessaire de ré-installer :
```
An error occurred while loading ./spec/lib/process_inbound_message_spec.rb. - Did you mean?
                    rspec ./spec/models/message_spec.rb

Failure/Error: require "charlock_holmes"

LoadError:
  dlopen(/Users/jean_scalingo/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/charlock_holmes-0.7.7/lib/charlock_holmes/charlock_holmes.bundle, 0x0009): Library not loaded: /usr/local/opt/icu4c/lib/libicudata.69.dylib
    Referenced from: /Users/jean_scalingo/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/charlock_holmes-0.7.7/lib/charlock_holmes/charlock_holmes.bundle
    Reason: tried: '/usr/local/opt/icu4c/lib/libicudata.69.dylib' (no such file), '/usr/local/lib/libicudata.69.dylib' (no such file), '/usr/lib/libicudata.69.dylib' (no such file), '/usr/local/Cellar/icu4c/70.1/lib/libicudata.69.dylib' (no such file), '/usr/local/lib/libicudata.69.dylib' (no such file), '/usr/lib/libicudata.69.dylib' (no such file) - /Users/jean_scalingo/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/charlock_holmes-0.7.7/lib/charlock_holmes/charlock_holmes.bundle
# ./lib/services/process_inbound_message.rb:3:in `<top (required)>'
# ./spec/lib/process_inbound_message_spec.rb:5:in `<top (required)>'
```
