ifeq (tests,$(firstword $(MAKECMDGOALS)))
  T_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(T_ARGS):;@:)
endif

ifeq (g,$(firstword $(MAKECMDGOALS)))
  G_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(G_ARGS):;@:)
endif

# default to compose v1
COMPOSE_CMD := docker-compose
# check if v2 exists by trying its 'version' command
# change COMPOSE_CMD if it does
ifneq ($(shell docker compose version 2>/dev/null), )
    COMPOSE_CMD := docker compose
endif

build:
	$(COMPOSE_CMD) build

up:
	$(COMPOSE_CMD) up -d

up-logs:
	$(COMPOSE_CMD) up

down:
	$(COMPOSE_CMD) down

stop:
	$(COMPOSE_CMD) stop

reset_db:
	$(COMPOSE_CMD) run web bin/rails db:drop db:create db:schema:load db:seed

db_load_seed:
	$(COMPOSE_CMD) run web bin/rails db:schema:load db:seed

create_db:
	$(COMPOSE_CMD) exec web bin/rails db:create

migrate:
	$(COMPOSE_CMD) exec web bin/rails db:migrate

migrate_status:
	$(COMPOSE_CMD) exec web bin/rails db:migrate:status

rollback:
	$(COMPOSE_CMD) exec web bin/rails db:rollback

bash:
	$(COMPOSE_CMD) exec web bash

c:
	$(COMPOSE_CMD) exec web bin/rails c

# used for interacting with the web docker when using debugger()
debug-web:
	$(COMPOSE_CMD) attach web

routes:
	$(COMPOSE_CMD) exec web bin/rails routes

sidekiq:
	$(COMPOSE_CMD) exec web bundle exec sidekiq --config ./config/sidekiq.yml

clock:
	$(COMPOSE_CMD) exec web bundle exec clockwork clock.rb

tests:
	$(COMPOSE_CMD) exec -e RAILS_ENV=test web bundle exec rspec $(T_ARGS)
