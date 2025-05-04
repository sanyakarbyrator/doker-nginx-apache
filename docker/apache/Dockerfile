FROM php:8.2-apache

# Копируем наш index/info.php в стандартную папку Apache
COPY cont/ /var/www/html/

# Меняем порт на 8888 в конфиге Apache
RUN sed -i 's/80/8888/g' /etc/apache2/ports.conf \
 && sed -i 's/*:80/*:8888/g' /etc/apache2/sites-available/000-default.conf

# Открываем порт
EXPOSE 8888

# Apache запустится автоматически при запуске контейнера

