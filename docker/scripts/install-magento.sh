#!/bin/bash

# Path: ./scripts/install-magento.sh

# Comprueba si Magento ya está instalado
if [ ! -f "app/etc/env.php" ]; then
    php bin/magento setup:install \
        --base-url="${BASE_URL}" \
        --db-host="${DB_HOST}" \
        --db-name="${DB_DATABASE}" \
        --db-user="${DB_USER}" \
        --db-password="${DB_PASSWORD}" \
        --admin-firstname="${ADMIN_FIRSTNAME}" \
        --admin-lastname="${ADMIN_LASTNAME}" \
        --admin-email="${ADMIN_EMAIL}" \
        --admin-user="${ADMIN_USER}" \
        --admin-password="${ADMIN_PASSWORD}" \
        --use-rewrites="${USE_REWRITES}" \
        --backend-frontname="${BACKEND_FRONTNAME}" \
        --db-prefix="${DB_PREFIX}" \
        --search-engine="${SEARCH_ENGINE}" \
        --elasticsearch-host="${ELASTICSEARCH_HOST}" \
        --elasticsearch-port="${ELASTICSEARCH_PORT}" \

    php bin/magento indexer:reindex

    php bin/magento setup:upgrade

    php bin/magento setup:static-content:deploy -f

    php bin/magento module:disable Magento_TwoFactorAuth

    php bin/magento cache:flush
fi

# Inicia el servidor Apache para mantener el contenedor corriendo
apache2-foreground
