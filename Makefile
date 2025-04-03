# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rsilva-e <rsilva-e@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/04 11:28:06 by rsilva-e          #+#    #+#              #
#    Updated: 2025/04/03 17:41:37 by rsilva-e         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME := inception
COMPOSE	:= srcs/docker-compose.yml
CONTENT := "127.0.0.1 rsilva-e.42.pt rsilva-e.42.fr"

all: run

check_host:
	@ if ! grep -Fxq ${CONTENT} /etc/hosts; then \
		echo "Creating host entry..."; \
		echo "${CONTENT}" | sudo tee -a /etc/hosts > /dev/null \
	else \
		echo "Host entry already exists."; \
	fi

check_volume_folder:
	@echo "check volumes"
	@ if [ ! -d "/home/rsilva-e/data/db" ] || [ ! -d "/home/rsilva-e/data/wp" ] ; then \
		mkdir -p /home/rsilva-e/data/db /home/rsilva-e/data/wp; \
		echo "HOST VOLUMES CREATE"; \
	else \
		echo "HOST VOLUMES ALREADY EXISTS"; \
	fi

# Uses docker-compose build to build the images defined in docker-compose.yml.
build: check_host check_volume_folder
	docker-compose -p $(NAME) -f $(COMPOSE) build

run: check_host check_volume_folder   # Uses docker-compose up -d to start the services in detached mode.
	docker-compose -p $(NAME) -f $(COMPOSE) up --build && \
	trap "make stop" EXIT

stop:   # Uses docker-compose down to stop and remove the containers.
	docker-compose -p $(NAME) stop

status:
	@docker image ls
	@docker volume ls
	@docker network ls
	@docker ps -a

# clean:
# 	@docker ps -q | xargs -r docker stop
# 	@docker ps -aq | xargs -r docker rm -f
# 	@docker images -q | xargs -r docker rmi -f
# 	@docker volume ls -q | xargs -r docker volume rm
# 	@docker volume prune -f
# 	@docker network ls --format "{{.ID}} {{.Name}}" | grep -v -E ' bridge| host| none' | awk '{print $1}' | xargs -r docker network rm
# 	@docker network prune -f
# 	@docker system prune -a --volumes -f

clean:		
	@ echo "docker containers all REMOVE"
	@docker-compose -p $(NAME) -f $(COMPOSE) down --rmi all --volumes

fclean: clean
	@ echo "all REMOVE"
	@sudo rm -rf /home/rsilva-e/data;

# fclean: clean status
# 	@sudo rm -rf /home/rsilva-e/data

re: clean all

.PHONY:	all build run stop clean fclean re check_host check_volume_folder