NAME= inception

SRCS= ./srcs
COMPOSE= $(SRCS)/docker-compose.yml
HOST_URL= dgomez-a.42.fr
DATA_DIR= $(HOME)/data
DB_DIR= $(DATA_DIR)/database
WP_DIR= $(DATA_DIR)/wordpress_files
DOCKER_COMPOSE= docker compose -f $(COMPOSE)

all: up

up:
	@mkdir -p $(DB_DIR) $(WP_DIR)
	@grep -q "$(HOST_URL)" /etc/hosts || printf "127.0.0.1 %s\n" "$(HOST_URL)" | sudo tee -a /etc/hosts > /dev/null
	@$(DOCKER_COMPOSE) up -d --build

down:
	@sudo sed -i '\#$(HOST_URL)#d' /etc/hosts
	@$(DOCKER_COMPOSE) down --remove-orphans

clean: down

fclean:
	@sudo sed -i '\#$(HOST_URL)#d' /etc/hosts
	@$(DOCKER_COMPOSE) down --remove-orphans --rmi all -v
	@docker builder prune -af

re: fclean up

.PHONY: all up down clean fclean re
