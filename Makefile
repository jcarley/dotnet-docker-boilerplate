# Metadata about this makefile and position
MKFILE_PATH := $(lastword $(MAKEFILE_LIST))
CURRENT_DIR := $(dir $(realpath $(MKFILE_PATH)))
CURRENT_DIR := $(CURRENT_DIR:/=)
USER_UID := $(shell id -u)
USER_GID := $(shell id -g)

shell:
	@USER_UID=$(USER_UID) USER_GID=$(USER_GID) docker-compose run --rm --service-ports shell

shell.rebuild:
	@docker container prune -f && docker image prune -f && docker rmi dcc:latest && USER_UID=$(USER_UID) USER_GID=$(USER_GID) docker-compose run --rm --service-ports shell

down:
	@docker-compose down --rmi local -v --remove-orphans

.PHONY: shell shell.rebuild
