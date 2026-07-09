all:
	@docker compose -f ./srcs/docker-compose.yml up --build -d

down:
	@docker compose -f ./srcs/docker-compose.yml down

re:
	@docker compose -f ./srcs/docker-compose.yml down
	@docker compose -f ./srcs/docker-compose.yml up --build -d

clean:
	@docker stop $$(docker ps -qa); \
	docker rm $$(docker ps -qa); \
	docker rmi $$(docker images -qa); \
	docker volume rm $$(docker volume ls -q); \

fileclean:
	@echo "Removing data directories..."
	@sudo rm -rf /home/vanfossi/data/db_data
	@mkdir -p /home/vanfossi/data/db_data
	@sudo rm -rf /home/vanfossi/data/wp_data
	@mkdir -p /home/vanfossi/data/wp_data

fclean: clean fileclean

.PHONY: all down re clean fclean fileclean