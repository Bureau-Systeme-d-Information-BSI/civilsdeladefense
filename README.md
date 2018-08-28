# Civilsdeladefense

Application de gestion de recrutements.

## Environnement de développement

Application Ruby on Rails avec base de données PostgreSQL, assets compilés avec webpack, suite de tests avec RSpec.

Des fichiers de définition Docker docker-compose sont présents pour faciliter la mise en place de l'environnements de développement.

Build des images Docker :

```
docker-compose build
```

Démarrage des images

```
docker-compose down && docker-compose up
```

## Lancer les tests

```
docker-compose run web rspec
```
