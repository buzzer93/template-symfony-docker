FROM php:8.2-apache

# 1) Paquets requis + nettoyage
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      curl ca-certificates git unzip \
    ; rm -rf /var/lib/apt/lists/*

# 2) Apache modules utiles
RUN a2enmod rewrite headers

# 3) install-php-extensions (sans ADD distant)
RUN curl -fsSL https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions -o /usr/local/bin/install-php-extensions \
 && chmod +x /usr/local/bin/install-php-extensions \
 && install-php-extensions pdo_mysql mysqli zip gd intl opcache bcmath

# 4) Composer (TLS OK) + cache bind
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php \
 && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm -f /tmp/composer-setup.php

WORKDIR /var/www

# 5) Caching deps PHP
COPY --chown=www-data:www-data composer.json composer.lock ./
RUN --mount=type=cache,target=/tmp/composer-cache \
    composer install --no-dev --optimize-autoloader --prefer-dist --no-interaction --no-progress -d /var/www

# 6) Code de l’app
COPY --chown=www-data:www-data . /var/www

# 7) (Optionnel) Build front si tu tiens à le faire ici (déconseillé)
# RUN npm ci && npm run build

# 8) Appliquer ta conf Apache
COPY ./docker/apache.conf /etc/apache2/sites-available/000-default.conf

# 9) Entrypoint/script
COPY ./docker/docker.sh /var/www/docker.sh
RUN chmod +x /var/www/docker.sh
ENTRYPOINT ["bash", "/var/www/docker.sh"]

EXPOSE 80
