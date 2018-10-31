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
Lancement d'une migration de base :

docker-compose run web rails db:migrate


Démarrage des images :

```
docker-compose down && docker-compose up
```

## Workflow de développement

Le workflow de développement est basé sur le [GitHub flow](https://guides.github.com/introduction/flow/) :

* chaque changement de code (nouvelle fonctionnialité, bug fix, etc) devrait résulter d'un ticket (une *issue* GitHub)
* chaque changement de code devrait passer une *review* de code via une Pull Request

La bonne manière de créer une Pull Request est de :

* créer localement une nouvelle branche correspondant au ticket/issue qu'on veut traiter via ```git checkout master && git pull && git checkout -b fix/13```
* modifier le code et accumuler les commits dans cette nouvelle branch. Les commits devraient mentionner le ticket correspondant (utiliser les mot-clés *fix* or *see*)
* pousser le code vers GitHub ```git push origin fix/13```
* ouvrir une PUll Request
* attendre la review de code et éventuellement modifier son code en fonction des commentaires

## Lancer les tests

```
docker-compose run specs rspec
```

## Déploiement en préproduction

Actuellement, la branche master est autodéployée sur la version Scalingo.

## Déploiement en production

Au préalable, les variables d'environnement PRODUCTION_SERVER_IP et PRODUCTION_SERVER_USER doivent être définies sur votre poste local, par exemple dans un fichier .env à la racine du projet.

Branchement sur "production" :
```
git checkout master && git pull && git checkout production && git merge master && git push origin production
```

Déploiement de la branche production avec Capistrano :
```
docker-compose run web cap production deploy
```

