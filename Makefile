MAKEFLAGS += --silent

# ----- Config ----- #

ENV_FILE=.env

# -- Dependencies -- #

include .env

# ----- Advanced ----- #

build:  ## Build App
	@docker compose --env-file $(ENV_FILE) build

up:  ## Up App
	@docker compose --env-file $(ENV_FILE) up -d app

down:  ## Down App
	@docker compose --env-file $(ENV_FILE) rm -sf app

run:  ## Execute App with $SHELL
	@clear
	@docker exec -it "$(APP_NAME)" bash

log:  ## Attach App logs
	-@docker logs -f "$(APP_NAME)" --tail=50
