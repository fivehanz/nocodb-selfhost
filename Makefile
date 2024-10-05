MAKEFLAGS += -j2

nginx-init: prod-nginx-link


### PRODUCTION COMMANDS
# prod-start:
# 	docker compose --env-file .env --file ./docker-compose.yml up -d
# prod-rebuild:
# 	docker compose --env-file .env --file ./docker-compose.yml up -d --build
# prod-restart:
# 	docker compose --env-file .env --file ./docker-compose.yml up -d --force-recreate	
# prod-stop:
# 	docker compose --env-file .env --file ./docker-compose.yml down

# docker swarm
STACK_NAME = nocodb
COMPOSE_FILE = ./docker-swarm.yml
ENV_FILE = .env

prod-start:
	docker stack deploy --env-file $(ENV_FILE) -c $(COMPOSE_FILE) $(STACK_NAME)

prod-update: prod-start

prod-force-update:
	docker service update --force $(STACK_NAME)_nocodb
	docker service update --force $(STACK_NAME)_nocodb_root_db
	docker service update --force $(STACK_NAME)_nocodb_redis

prod-stop:
	docker stack stop $(STACK_NAME)  # Stops services without removing configuration.

prod-rm:
	docker stack rm $(STACK_NAME)  # Removes the stack and all associated resources.


prod-nginx-link:
	ln -s ${shell pwd}/vhost.conf /etc/nginx/sites-enabled/db.jsmx.org.conf
	nginx -s reload
