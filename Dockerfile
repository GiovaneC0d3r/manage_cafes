FROM richarvey/nginx-php-fpm:1.7.2

# Instalar Node + NPM (para build do frontend)
RUN apt-get update && apt-get install -y nodejs npm git && npm install -g npm@latest

# Copiar o projeto
COPY . /var/www/html

# Variáveis de ambiente
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /var/www/html

# Instalar dependências PHP
RUN composer install --no-dev --optimize-autoloader

# Build do frontend (Vite + Inertia + Vue)
RUN npm install
RUN npm run build

# Ajustar permissões
RUN chown -R www-data:www-data storage bootstrap/cache

# Rodar deploy script
COPY scripts/00-laravel-deploy.sh /scripts/00-laravel-deploy.sh
RUN chmod +x /scripts/00-laravel-deploy.sh
RUN /scripts/00-laravel-deploy.sh

# Porta usada pelo Render
EXPOSE 8080

# Comando de inicialização
CMD ["/start.sh"]
