# Dockerize Magento 2

## Environment versions

- Windows 11 Pro v23H2
- WSL2 v2.0.9
- Ubuntu 20.04.6 LTS
- Docker Desktop v4.25.2
- Docker version 24.0.7
- Docker Compose version v2.18.1

## Post url adapted to Docker

[How to Install Magento 2 on Ubuntu 20.04 LTS](https://allthings.how/how-to-install-magento-2-on-ubuntu-20-04-lts/)

## Create env file

```bash
cp .env.example .env
```

Note: Change the values of the variables in the .env file

## Create auth.json file

```bash
cp auth.json.example auth.json
```

Note: Change the values of the variables in the auth.json file

## Build docker

```bash
docker compose -p magento2_project -f docker/docker-compose.yml build --no-cache
```

## Run docker

```bash
docker compose -p magento2_project -f docker/docker-compose.yml up -d --build --remove-orphans --force-recreate
```

## Build and run docker

```bash
docker compose -p magento2_project -f docker/docker-compose.yml build --no-cache && docker compose -p magento2_project -f docker/docker-compose.yml up -d --build --remove-orphans --force-recreate
```

## TODOs

- [ ] tests in other versions of Php
