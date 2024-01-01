# Path: Dockerfile

# Usa una imagen base con PHP 7.4
FROM php:7.4-apache

# Configuración recomendada de PHP para Magento
RUN echo 'file_uploads = On\n\
allow_url_fopen = On\n\
short_open_tag = On\n\
    memory_limit = 2G\n\
cgi.fix_pathinfo = 0\n\
upload_max_filesize = 100M\n\
    max_execution_time = 1800\n\
    zlib.output_compression = On\n' > /usr/local/etc/php/conf.d/magento-recommended.ini

# Configuración de Apache
RUN { \
        echo '<VirtualHost *:80>'; \
    echo '  ServerAdmin webmaster@localhost'; \
        echo '  DocumentRoot /var/www/html'; \
        echo '  <Directory "/var/www/html">'; \
        echo '    AllowOverride All'; \
        echo '  </Directory>'; \
        echo '  ServerName localhost'; \
    echo '  ServerAlias localhost'; \
    echo '  ErrorLog ${APACHE_LOG_DIR}/error.log'; \
    echo '  CustomLog ${APACHE_LOG_DIR}/access.log combined'; \
        echo '</VirtualHost>'; \
    } > /etc/apache2/sites-available/000-default.conf

# Habilitar mod_rewrite y reiniciar Apache
RUN a2enmod rewrite
RUN service apache2 restart

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Instalar dependencias necesarias para las extensiones PHP
RUN apt-get update && apt-get install -y \
    default-mysql-client \
    netcat \
    libonig-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libicu-dev \
    libxslt1-dev \
    libzip-dev \
    libssl-dev \
    libwebp-dev \
    libjpeg-dev \
    zlib1g-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd soap intl xsl zip sockets pdo_mysql mbstring exif pcntl bcmath

# Copiar el código fuente de Magento 2 en el contenedor
COPY . .

# Instalar dependencias con Composer
RUN composer install --no-interaction --optimize-autoloader

# Ajustar permisos
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + && \
    find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + && \
    chmod u+x bin/magento && \
    chown -R www-data:www-data .

# Establecer permisos
RUN chmod -Rf 777 var && chmod -Rf 777 pub/static && chmod -Rf 777 pub/media && chmod 777 ./app/etc && chmod 644 ./app/etc/*.xml && chmod -Rf 775 bin

# Copiar scripts al contenedor
COPY ./scripts/install-magento.sh /usr/local/bin/install-magento.sh
COPY ./scripts/wait-for-it.sh /usr/local/bin/wait-for-it.sh

# Dar permisos de ejecución a los scripts
RUN chmod +x /usr/local/bin/install-magento.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh

# Establecer el ENTRYPOINT para ejecutar wait-for-it.sh primero y luego install-magento.sh
ENTRYPOINT ["/usr/local/bin/wait-for-it.sh", "/usr/local/bin/install-magento.sh"]

# Exponer el puerto 80
EXPOSE 80
