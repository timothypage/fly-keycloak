# Keycloak on fly.io

keycloak version 22.0.3

## Running locally

```bash
pwgen -s 32 1

docker compose up keycloakdb

docker compose exec keycloakdb psql
```

```sql
CREATE ROLE keycloak WITH LOGIN PASSWORD '<password-from-pwgen-above>';
CREATE DATABASE keycloak OWNER = keycloak;
```

see `.env` for local environment config


## Deploy app

create a database if needed, this can be used by any app in your organization

```bash
fly postgres create
```

login and create a user for keycloak
```bash
pwgen -s 32 1

fly postgres connect -a com-tzwolak-prod-db
```

```sql
CREATE ROLE keycloak WITH LOGIN PASSWORD '<password-from-pwgen-above>';
CREATE DATABASE keycloak OWNER = keycloak;
```

create the fly app (keycloak needs a minimum of 512MB of memory, and needs special configuration to run in cluster mode)
```
fly launch

fly scale count 1

fly scale memory 512
```

setup secrets
```bash
fly secrets set KC_DB_PASSWORD=<password-from-pwgen-above>

export PW=$(pwgen -s 32 1); echo KEYCLOAK_ADMIN_PASSWORD=$PW; fly secrets set KEYCLOAK_ADMIN_PASSWORD=$PW; unset $PW
```


set up your DNS via your domain registrar or DNS provider
```
auth.tzwolak.com CNAME com-tzwolak-auth.fly.dev
```

create a ssl certificate
```bash
fly certs create auth.tzwolak.com -a com-tzwolak-auth
fly certs check auth.tzwolak.com -a com-tzwolak-auth
```
