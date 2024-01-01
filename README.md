# Dockerize Magento 2

## Environment versions

- Windows 11 Pro v23H2
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

## Run project

```bash
docker compose up -d --build --remove-orphans --force-recreate
```
