DOCKER-APP-EXEC = docker-compose exec -it php-fpm /bin/sh -c

ssh: ## Connect to containers via SSH
	docker-compose exec -it php-fpm /bin/sh

setup-dev: ## Setup project for development
	make start
	make composer-install

start: ## Start application silently
	docker-compose up -d --build

stop: ## Stop application
	docker-compose down

restart: ## Restart the application
	make stop
	make start

composer-install: ## Install composer dependencies
	$(DOCKER-APP-EXEC) 'composer install'

composer-dump: ## Dump composer dependencies
	$(DOCKER-APP-EXEC) 'composer dump'

composer-update: ## Update composer dependencies
	$(DOCKER-APP-EXEC) 'composer update $(filter-out $@,$(MAKECMDGOALS))'

run: ## Run command in the container
	$(DOCKER-APP-EXEC) '$(filter-out $@,$(MAKECMDGOALS))'