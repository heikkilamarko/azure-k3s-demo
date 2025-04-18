# Keycloak

## Build

```bash
./ci.sh <docker_image_tag>
```

## Deploy

```bash
./cd.sh <docker_image_tag>
```

## Use

Admin Console: https://keycloak.local/auth

Follow the well-known URL when testing cluster fault tolerance:

```bash
watch curl -s -k https://keycloak.local/auth/realms/master/.well-known/openid-configuration
```

## Clean Up

```bash
./cleanup.sh
```
