# Etapa 1: Builder - instala dependências e compila frontend
FROM composer:2 AS build-composer
FROM node:18 AS build-node

WORKDIR /app

# Copiar arquivos de definição
COPY composer.json composer.lock package*.json ./

# Copiar código para a imagem
COPY . .

# Instalar dependências PHP
RUN apt-get update && apt-get install -y php-cli php-mbstring php-xml php-bcmath php-curl unzip git && \
    composer install --no-dev --optimize-autoloader

# Instalar dependências JS e buildar frontend
RUN npm install && npm run build

# Etapa 2: Execução - imagem leve do PHP + Nginx (Render-friendly)
FROM richarvey/nginx-php-fpm:latest

WORKDIR /var/www/html

# Copiar arquivos do app e build já prontos
COPY --from=build-node /app ./

# Permissões para storage e cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Porta usada pelo Render
EXPOSE 8080

# Comando de inicialização
CMD ["supervisord", "-n", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
