#@ removes cmd display
#- ignores return codes (keep going if makefile cmd fails)

all:
	mkdir -p ${HOME}/data/wp_data
	mkdir -p ${HOME}/data/db_data
	BUILD_BONUS=no docker compose -f ./srcs/docker-compose.yml up --build -d  nginx wordpress mariadb

bonus:
	mkdir -p ${HOME}/data/wp_data
	mkdir -p ${HOME}/data/db_data
	BUILD_BONUS=yes docker compose -f ./srcs/docker-compose.yml up --build -d

up:
	docker compose -f ./srcs/docker-compose.yml up -d nginx wordpress mariadb

upbonus:
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down

re:
	docker compose -f ./srcs/docker-compose.yml down
	docker compose -f ./srcs/docker-compose.yml up --build -d

clean:
	-docker stop $$(docker ps -qa)
	-docker rm $$(docker ps -qa)
	-docker rmi $$(docker images -qa)
	-docker volume rm $$(docker volume ls -q)
	-docker network rm srcs_inception_net

fileclean:
	-echo "Removing data directories..."
	-sudo rm -rf ${HOME}/data/db_data
	-sudo rm -rf ${HOME}/data/wp_data

fclean: clean fileclean

.PHONY: all down re clean fclean fileclean