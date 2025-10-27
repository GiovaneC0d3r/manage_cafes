#!/usr/bin/env bash

echo "Installing NPM dependencies..."
cd /var/www/html
npm install

echo "Building frontend assets..."
npm run build

echo "Running composer..."
composer install --no-dev --working-dir=/var/www/html

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Running migrations..."
php artisan migrate --force
