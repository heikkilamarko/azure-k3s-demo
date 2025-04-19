# Keycloak

## Build

```bash
./ci.sh <keycloak_version>
```

## Deploy

```bash
./cd.sh <keycloak_version>
```

## Use

Admin Console: https://keycloak.local/auth/admin/master/console/

Follow the well-known URL when testing cluster fault tolerance:

```bash
watch curl -s -k https://keycloak.local/auth/realms/master/.well-known/openid-configuration
```

## Clean Up

```bash
./cleanup.sh <keycloak_version>
```

## Notes

### Upgrade from `23.0` to `24.0`

```text
ERROR [org.infinispan.CLUSTER] (jgroups-5,keycloak-2-41043) ISPN000475: Error processing response for request 2 from keycloak-1-61566: java.io.IOException: Unknown type: 28
```

Requires scaling `StatefulSet` down to `1` replicas before upgrading. After upgrade, scale back up to `3`.
