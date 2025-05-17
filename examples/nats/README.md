# NATS

## Add the chart repository

```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
```

## Update the chart repository

```bash
helm repo update
```

## Create the NATS auth resources

```bash
./nats-auth-create.sh
```

## Prepare the NATS server config

```bash
./nats-server-config-create.sh
```

Copy the `merge` block from the generated `nats-server.conf/values.yaml` file into the `values.yaml` file.

## Render chart templates locally

```bash
helm template nats nats/nats --values values.yaml > manifest.yaml
```

## Install the chart

```bash
helm install nats nats/nats --values values.yaml --namespace examples
```

## Push the NATS auth resources to the cluster

```bash
./nats-auth-push.sh
```

## Uninstall the chart

```bash
helm uninstall nats --namespace examples
```
