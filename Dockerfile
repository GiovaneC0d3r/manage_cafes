# Etapa 1: Build de assets
FROM node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Etapa 2: PHP + Nginx para produção
FROM php:8.2-fpm

# Instalar dependências
RUN apt-get update && apt-get install -y \
    nginx \
    libzip-dev \
    libpq-dev \
    unzip \
    git \
    curl && \
    docker-php-ext-install pdo_pgsql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copiar aplicação
WORKDIR /var/www/html
COPY . .
COPY --from=build /app/public/build ./public/build

# Instalar dependências PHP
RUN composer install --no-dev --optimize-autoloader

# Permissões
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copiar configuração do Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta
EXPOSE 8080

# Start Nginx + PHP-FPM
CMD service nginx start && php-fpm
