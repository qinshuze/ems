FROM php:7.3-fpm-alpine
LABEL authors="qsz"

RUN sed -i 's|dl-cdn.alpinelinux.org|mirrors.ustc.edu.cn|g' /etc/apk/repositories

RUN addgroup -g 1001 www && adduser -D -u 1000 -G www -s /bin/sh www
RUN cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN sed -i 's|user = www-data|user = www|g' /usr/local/etc/php-fpm.d/www.conf \
    && sed -i 's|group = www-data|group = www|g' /usr/local/etc/php-fpm.d/www.conf

RUN apk update && \
    apk add --no-cache \
    libpng libzip libxml2 libzip-dev libxml2-dev freetype libjpeg-turbo freetype-dev libjpeg-turbo-dev
RUN docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir
RUN docker-php-ext-install pdo_mysql gd zip xml

RUN apk del freetype-dev libjpeg-turbo-dev libzip-dev libxml2-dev \
    && rm /var/cache/apk/*

COPY ./composer /usr/local/bin
RUN chmod +x /usr/local/bin/composer