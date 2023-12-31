#!/bin/bash

# Path: ./scripts/wait-for-it.sh

set -e

# Comando a ejecutar una vez que ambos servicios estén disponibles
cmd="$@"

# Host y puerto de MySQL
mysql_host="db"
mysql_port=3306
# Esperar a que MySQL esté disponible
until nc -z "$mysql_host" $mysql_port; do
  >&2 echo "MySQL is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySQL is up"

# Host y puerto de Elasticsearch
elasticsearch_host="elasticsearch"
elasticsearch_port=9200
# Esperar a que Elasticsearch esté disponible
until nc -z "$elasticsearch_host" $elasticsearch_port; do
  >&2 echo "Elasticsearch is unavailable - sleeping"
  sleep 1
done

>&2 echo "Elasticsearch is up"

# Ejecutar el comando
exec $cmd
