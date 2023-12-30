# Path: Dockerfile

# Usa una imagen base con PHP 7.4
FROM php:7.4-apache

RUN a2enmod rewrite

RUN echo 'file_uploads = On\n\
allow_url_fopen = On\n\
short_open_tag = On\n\
memory_limit = 256M\n\
cgi.fix_pathinfo = 0\n\
upload_max_filesize = 100M\n\
max_execution_time = 360\n' > /usr/local/etc/php/conf.d/magento-recommended.ini

RUN { \
        echo '<VirtualHost *:80>'; \
        echo '  DocumentRoot /var/www/html'; \
        echo '  <Directory "/var/www/html">'; \
        echo '    AllowOverride All'; \
        echo '  </Directory>'; \
        echo '  ServerName localhost'; \
        echo '</VirtualHost>'; \
    } > /etc/apache2/sites-available/000-default.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

# Instala las dependencias necesarias, incluyendo oniguruma para mbstring
RUN apt-get update && apt-get install -y \
        libonig-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Instala las extensiones necesarias de PHP
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath

# Copia el código fuente de Magento 2 en el contenedor
COPY . .

# Ajusta los permisos para la carpeta var/ y subcarpetas
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + && chmod u+x bin/magento && chown -R :www-data .

RUN chmod -Rf 777 var
RUN chmod -Rf 777 pub/static
RUN chmod -Rf 777 pub/media
RUN chmod 777 ./app/etc
RUN chmod 644 ./app/etc/*.xml
RUN chmod -Rf 775 bin

# Expone el puerto 80
EXPOSE 80
