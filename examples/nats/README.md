# NATS Example

## Add the chart repository

```bash
helm repo add nats https://nats-io.github.io/k8s/helm/charts/
```

## Update the chart repository

```bash
helm repo update
```

## Render chart templates locally

```bash
helm template nats nats/nats --values values.yaml > manifest.yaml
```

## Install the chart

```bash
helm install nats nats/nats --values values.yaml --namespace examples
```

## Uninstall the chart

```bash
helm uninstall nats --namespace examples
```
