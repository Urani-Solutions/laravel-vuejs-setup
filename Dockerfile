FROM php:8.2-fpm

# Define a build argument for the user ID
ARG UID
ARG GID

# Copy composer.lock and composer.json
COPY composer.json /var/www/

# Set working directory
WORKDIR /var/www

USER root

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
 apt-get install -y \
    nodejs \
    # git for downloading composer package
    git \
    libicu-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libsqlite3-dev \
    # lib to install php zip
    zlib1g-dev \
    libzip-dev \
    libjpeg-dev \
    libpng-dev \
    supervisor \
  && apt-get clean

RUN pecl install pcov

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Clear cache
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*
RUN rm /usr/local/etc/php-fpm.d/zz-docker.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP Zip extension
RUN docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install zip pdo pdo_mysql pdo_sqlite gd

RUN docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install opcache

# Add user for laravel application
RUN groupadd -g "$GID" www
RUN useradd -u "$UID" -ms /bin/bash -g www www

# Copy existing application directory permissions
RUN chown -R www:www /var/www
RUN mkdir -p /run/php
RUN chown -R www:www /run/php

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000 6001
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
