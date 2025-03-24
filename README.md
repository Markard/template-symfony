This package provides a docker PHP Skeleton setup to start building your next idea.

## Getting Started
1. Setup `.env` from `.env.example` file.
2. Setup `docker/php-fpm/xdebug/xdebug.ini` from `docker/php-fpm/xdebug/xdebug.ini.example` file.
3. Setup `docker/php-fpm/php-fpm/www.conf` from `docker/php-fpm/php-fpm/www.conf.example` file.
4. Build containers with `docker-compose build && docker-compose up -d` command.
5. Setup `hosts` file with `127.0.0.1 localhost project.local www.project.local` domains.
6. Init php application in project folder. For example for symfony you could use command `docker-compose exec -it php-fpm composer create-project symfony/skeleton:"7.2.x-dev" .`

## Create Symfony application
1. Remove project/public/index.php folder
2. Create application with command `docker-compose exec -it php-fpm composer create-project symfony/skeleton:"7.2.x-dev" .` 
3. If you need composer or console interaction, use command like `docker-compose exec -it php-fpm composer`

Open www.project.local in your browser, phpinfo() should appear.