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

Optionnellement ce fichier .env peut contenir les variables suivantes pour configurer un Object Storage basé sur AWS S3 :

```
AWS_ACCESS_KEY_ID=XXX
AWS_SECRET_ACCESS_KEY=XXX
AWS_REGION=XX-XXXX-XX
AWS_BUCKET_NAME=XXX
```

Créer le fichier config/master.key contenat la clé principale : le contenu du fichier doit être demandée à l'équipe de développement.

Créer la base de données avec les données de seed :

```
docker-compose run web rails db:drop db:create db:schema:load db:seed
```

Démarrage des images :

```
docker-compose down && docker-compose up
```

## Lancer les tests

```
docker-compose run specs rspec
```
