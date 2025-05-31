# Step 1: Builder
FROM php:8.4-rc-fpm-alpine3.21 AS builder

## 1.1 Symfony deps: bcmath intl pdo
RUN apk add --no-cache icu-dev \
    && docker-php-ext-install bcmath intl pdo

## 1.2 PostgreSQL
RUN apk add postgresql-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/lib \
    && docker-php-ext-install pdo_pgsql pgsql

## 1.3 MySQL
RUN docker-php-ext-install mysqli pdo_mysql

## 1.4 XDebug
RUN apk add --update linux-headers \
    && apk --no-cache add ${PHPIZE_DEPS} \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

## 1.5 Redis
RUN apk add --update linux-headers \
    && apk --no-cache add pcre-dev ${PHPIZE_DEPS} \
    && pecl install redis \
    && docker-php-ext-enable redis.so

## 1.6 Memcached
ARG MEMCACHED_VERSION=3.3.0
RUN apk add zlib-dev libmemcached-dev git \
    && git clone --branch v$MEMCACHED_VERSION https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached/ \
    && docker-php-ext-configure memcached --disable-memcached-sasl \
    && docker-php-ext-install memcached

## 1.7 RabbitMQ (AMQP)
RUN apk add --update linux-headers \
    && apk --no-cache add rabbitmq-c-dev ${PHPIZE_DEPS} \
    && pecl install amqp \
    && docker-php-ext-enable amqp

## 1.8 Kafka
RUN apk add --update linux-headers \
    && apk --no-cache add librdkafka-dev ${PHPIZE_DEPS} \
    && pecl install rdkafka \
    && docker-php-ext-enable rdkafka

## 1.9 libzip
RUN apk add libzip-dev zip \
    && apk add --no-cache libzip \
    && docker-php-ext-install zip

## Install Symfony-cli
RUN apk add --no-cache bash \
&& curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash \
&& apk add symfony-cli

#-----------------------------------------------------------------------------------------------------------------------

# Step 2: Final
FROM php:8.4-rc-fpm-alpine3.21

## Dependencies
### 1. Memcached
RUN apk add libmemcached \
### 2. intl
    icu \
### 3. PostgreSQL
    libpq \
### 7. RabbitMQ (AMQP)
    rabbitmq-c \
### 8. Kafka
    librdkafka \
### 9. libzip
    libzip

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

## Install symfony-cli
COPY --from=builder /usr/bin/symfony /usr/bin/symfony

## Install composer
COPY --from=composer:2.8.9 /usr/bin/composer /usr/bin/composer

## Create user
ARG DOCKER_HOST_UID=1000
RUN echo http://mirror.yandex.ru/mirrors/alpine/edge/community/ >> /etc/apk/repositories \
    && apk add --no-cache --virtual usermod shadow \
    && usermod -u $DOCKER_HOST_UID www-data

## Init logs
### Common log folder
RUN mkdir /usr/local/log \
    && chown -R www-data:www-data /usr/local/log \
### Slow log
    && touch /usr/local/log/www.log.slow \
    && chown www-data:www-data /usr/local/log/www.log.slow \
### Access log
    && touch /usr/local/log/www.access.log \
    && chown www-data:www-data /usr/local/log/www.access.log

COPY php.ini /usr/local/etc/php/php.ini
COPY fpm-increase-timeout-for-debugging.conf /usr/local/etc/php-fpm.d/increase-timeout-for-debugging.conf

WORKDIR /var/www/project