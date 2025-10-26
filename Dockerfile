# ==============================
# ETAPA 1: Build dos assets com Node + PHP
# ==============================
FROM php:8.2-cli AS build

# Instalar Node e dependências do sistema
RUN apt-get update && apt-get install -y nodejs npm git unzip libzip-dev libpq-dev && \
    docker-php-ext-install pdo_pgsql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos necessários
COPY composer.* package*.json ./

# Instalar dependências PHP e JS
RUN composer install --no-dev --optimize-autoloader
RUN npm install

# Copiar o restante do código
COPY . .

# Gerar tipos e buildar o frontend (Wayfinder + Vite)
RUN php artisan wayfinder:generate --with-form || true
RUN npm run build

# ==============================
# ETAPA 2: PHP-FPM + Nginx para produção
# ==============================
FROM php:8.2-fpm

# Instalar Nginx e dependências
RUN apt-get update && apt-get install -y nginx libzip-dev libpq-dev unzip git curl && \
    docker-php-ext-install pdo_pgsql zip

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Diretório de trabalho
WORKDIR /var/www/html

# Copiar aplicação e build do frontend
COPY . .
COPY --from=build /app/public/build ./public/build

# Instalar dependências PHP (somente produção)
RUN composer install --no-dev --optimize-autoloader

# Ajustar permissões
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copiar configuração do Nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta
EXPOSE 8080

# Rodar Nginx + PHP-FPM
CMD service nginx start && php-fpm
