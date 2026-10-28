FROM php:8.3.35-fpm-alpine
WORKDIR /var/www/html
EXPOSE 9000
CMD ["php-fpm"]
