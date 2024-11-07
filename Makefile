# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rsilva-e <rsilva-e@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/05/04 11:28:06 by rsilva-e          #+#    #+#              #
#    Updated: 2024/11/07 22:38:51 by rsilva-e         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME := inception
COMPOSE	:= srcs/docker-compose.yml

all: build run

build:	# Uses docker-compose build to build the images defined in docker-compose.yml.
	docker-compose -p $(NAME) -f $(COMPOSE) build

run:    # Uses docker-compose up -d to start the services in detached mode.
	docker-compose -p $(NAME) -f $(COMPOSE) up -d

stop:   # Uses docker-compose down to stop and remove the containers.
	docker-compose -p $(NAME) down

status:
	@docker image ls
	@docker volume ls
	@docker network ls
	@docker ps -a

clean:
	docker-compose -p $(NAME) down --rmi all

fclean: clean
	docker volume rm $$(docker volume ls -q)
	sudo rm -rf ~/data/wordpress/*
	sudo rm -rf ~/data/mariadb/*

re: clean all

.PHONY:	all build run stop clean fclean re