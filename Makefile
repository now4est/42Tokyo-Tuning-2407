SHELL := /bin/bash

MYSQL_LOG_DIR := /var/log/mysql
MYSQL_LOG := $(MYSQL_LOG_DIR)/slow.log
HOST_LOG := ./webapp/mysql/logs/slow.log
DATE := $(shell date '+%T')

all: test

test:
	docker compose -f ./webapp/docker-compose.local.yml up -d
	docker compose -f ./webapp/docker-compose.local.yml exec db touch $(MYSQL_LOG)
	docker compose -f ./webapp/docker-compose.local.yml exec db mv $(MYSQL_LOG) $(MYSQL_LOG).$(DATE)
	docker compose -f ./webapp/docker-compose.local.yml down
	docker compose -f ./webapp/docker-compose.local.yml up -d
	./run.sh
	mysqldumpslow -s t $(HOST_LOG) | \
	head -c 2000 | \
	jq -Rs '{username: "ろぐ子ちゃん", content: .}' | \
	curl -H "Content-Type: application/json" -X POST -d @- https://discord.com/api/webhooks/1266671844258349057/1pKcePHAIK1kC7NAqy_9N5ZLi2CkkDRRwsrKZwKOqbSPMx1o0Y9etZPvULl6150-g4UU
