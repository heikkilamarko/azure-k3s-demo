# NATS

## Add the chart repository

```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
```

## Update the chart repository

```bash
helm repo update
```

## Create NATS certs

```bash
./nats-certs-create.sh
```

## Generate NATS auth configuration

```bash
./nats-auth-create.sh
```

## Prepare the NATS server config

```bash
./nats-server-config-create.sh
```

Copy the `merge` block from the generated `nats-server.conf/values.yaml` file into the `values.yaml` file.

## Create NATS TLS secret

```bash
./nats-tls-secret-create.sh
```

## Render chart templates locally

```bash
envsubst < values.yaml | helm template nats nats/nats --values - > manifest.yaml
```

## Install the chart

```bash
envsubst < values.yaml | helm install nats nats/nats --namespace examples --values -
```

## Deploy the auth configuration to the NATS cluster

```bash
./nats-auth-push.sh
```

## Uninstall the chart

```bash
helm uninstall nats --namespace examples
```

## Delete the NATS TLS secret

```bash
./nats-tls-secret-delete.sh
```
