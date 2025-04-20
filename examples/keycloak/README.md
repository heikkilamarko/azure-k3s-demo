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

Follow the well-known URL when testing cluster upgrades, fault tolerance, and other related tasks:

```bash
watch curl -s -k https://keycloak.local/auth/realms/master/.well-known/openid-configuration
```

## Clean Up

```bash
./cleanup.sh <keycloak_version>
```

## Upgrade Keycloak Cluster

- [Keycloak Upgrading Guide](https://www.keycloak.org/docs/latest/upgrading/index.html)

  - [Upgrading the Keycloak server](https://www.keycloak.org/docs/latest/upgrading/index.html#_upgrading)

Even if a rolling update appears to work for most upgrades, it is recommended to shut down the old version before deploying the new one. This can be done by scaling the `StatefulSet` down to `1 replica` before upgrading. After the upgrade, scale it back up to `N replicas`.

### Notes

#### Keycloak 3-Node Cluster Upgrade from Version 23.0 to 24.0

The following error occurs during the upgrade:

```text
ERROR [org.infinispan.CLUSTER] (jgroups-5,keycloak-2-41043) ISPN000475: Error processing response for request 2 from keycloak-1-61566: java.io.IOException: Unknown type: 28
```

To avoid this, scale the `StatefulSet` down to `1 replica` before upgrading. After the upgrade, scale it back up to `3 replicas`.

> This is a known issue. See [Keycloak GitHub Issue](https://github.com/keycloak/keycloak/issues/28617) for more details.
