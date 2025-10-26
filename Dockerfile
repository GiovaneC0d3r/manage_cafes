# 1. Base PHP
FROM php:8.2-fpm

# 2. Instalar dependências do sistema
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git curl nodejs npm libpq-dev && \
    docker-php-ext-install pdo_pgsql zip

# 3. Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4. Configurar diretório de trabalho
WORKDIR /var/www/html

# 5. Copiar arquivos do projeto
COPY . .

# 6. Instalar dependências PHP
RUN composer install --no-dev --optimize-autoloader

# 7. Instalar dependências JS e compilar assets
RUN npm install
RUN npm run build

# 8. Permissões
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# 9. Expor porta
EXPOSE 8000

# 10. Comando para rodar Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
