#!/bin/bash

# Path: ./scripts/install-magento.sh

# Comprueba si Magento ya está instalado
if [ ! -f "app/etc/env.php" ]; then
    php bin/magento setup:install \
        --base-url="http://localhost:8087" \
        --db-host="db" \
        --db-name="magento2" \
        --db-user="root" \
        --db-password="123456" \
        --admin-firstname="Admin" \
        --admin-lastname="Admin" \
        --admin-email="admin@example.com" \
        --admin-user="admin" \
        --admin-password="Testing123%567" \
        --use-rewrites="1" \
        --backend-frontname="admin" \
        --db-prefix=mage_ \
        --search-engine="elasticsearch7" \
        --elasticsearch-host="elasticsearch" \
        --elasticsearch-port=9200

    php bin/magento indexer:reindex

    php bin/magento setup:upgrade

    php bin/magento setup:static-content:deploy -f

    php bin/magento module:disable Magento_TwoFactorAuth

    php bin/magento cache:flush
fi

# Inicia el servidor Apache para mantener el contenedor corriendo
apache2-foreground
