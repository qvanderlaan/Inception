all: up

up:
	@mkdir -p /home/qvan-der/data/mariadb /home/qvan-der/data/wordpress
	@docker compose -f ./srcs/docker-compose.yml up -d --build

build:
	@mkdir -p /home/qvan-der/data/mariadb /home/qvan-der/data/wordpress
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

fclean: down
	@docker run --rm -v /home/qvan-der/data:/cleanup debian:bullseye rm -rf /cleanup/mariadb /cleanup/wordpress 2>/dev/null || sudo rm -rf /home/qvan-der/data/mariadb/* /home/qvan-der/data/wordpress/* 2>/dev/null || true
	@docker volume prune --force
	@docker system prune -a --force

re: fclean all

.PHONY: all up build down stop start logs status status-a clean fclean re
