FROM php:7-cli

MAINTAINER Martin Kolek <kolek@modpreneur.com>

RUN apt-get update && apt-get -y install \
    apt-utils \
    libcurl4-openssl-dev \
    curl \
    wget\
    zlib1g-dev \
    git \
    nano

ADD docker/php.ini /usr/local/etc/php/

#add Debian servers up-to-date packages, install php ext and composer and xdebug
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
    && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
    && wget https://www.dotdeb.org/dotdeb.gpg \
    && apt-key add dotdeb.gpg \
    && apt-get update \
    && apt-get -y install \
    php7.0-cli \
    php7.0-apcu \
    sqlite3 \
    libsqlite3-dev \
    php7.0-sqlite3 \
    phpunit \
    && docker-php-ext-install curl zip mbstring opcache pdo_sqlite \
    && curl -sS https://getcomposer.org/installer | php \
    && cp composer.phar /usr/bin/composer \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/php.ini \
    && echo "alias composer=\"php -n -d extension=mbstring.so -d extension=zip.so -d extension=bcmath.so /usr/bin/composer\"" >> /etc/bash.bashrc

# terminal env for nano
ENV TERM xterm