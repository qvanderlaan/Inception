all: up

up:
	@mkdir -p /home/qvan-der/data/mariadb
	@docker compose -f ./srcs/docker-compose.yml up -d

build:
	@mkdir -p /home/qvan-der/data/mariadb
	@docker compose -f ./srcs/docker-compose.yml up --build -d

down:
	@docker compose -f ./srcs/docker-compose.yml down

stop:
	@docker compose -f ./srcs/docker-compose.yml stop

start:
	@docker compose -f ./srcs/docker-compose.yml start

logs:
	@docker compose -f ./srcs/docker-compose.yml logs

status:
	@docker ps

status-a:
	@docker ps -a

clean: down
	@docker system prune -a --force

fclean: clean
	@docker run --rm -v /home/qvan-der/data:/cleanup debian:bookworm rm -rf /cleanup/mariadb /cleanup/wordpress
	@docker volume prune --force

.PHONY: all up build down stop start logs status status-a clean fclean
