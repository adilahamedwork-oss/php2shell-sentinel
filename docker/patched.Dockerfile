FROM php:8.3.36-fpm-alpine
WORKDIR /var/www/html
EXPOSE 9000
CMD ["php-fpm"]
