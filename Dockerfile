# Etapa 1: Build do frontend e dependências PHP
FROM php:8.2-fpm AS build

# Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev libpq-dev nodejs npm && \
    docker-php-ext-install pdo_pgsql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiar tudo
COPY . .

# Instalar dependências PHP
RUN composer install --no-dev --optimize-autoloader

# Instalar dependências JS e buildar assets
RUN npm install && npm run build

# Etapa 2: Produção (PHP-FPM + Nginx)
FROM nginx:stable-alpine

# Instalar PHP-FPM
RUN apk add --no-cache php82 php82-fpm php82-pdo_pgsql php82-opcache php82-zip php82-mbstring php82-tokenizer php82-dom php82-session php82-fileinfo php82-curl

# Copiar app
WORKDIR /var/www/html
COPY --from=build /var/www/html .

# Copiar configuração do Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Permissões corretas
RUN chown -R nobody:nogroup storage bootstrap/cache

# Expor porta
EXPOSE 8080

# Rodar Nginx + PHP-FPM
CMD php-fpm82 -D && nginx -g 'daemon off;'
