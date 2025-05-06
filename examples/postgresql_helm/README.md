# PostgreSQL Helm Chart Example

## Add the chart repository

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

## Update the chart repository

```bash
helm repo update
```

## Render chart templates locally

```bash
helm template postgresql bitnami/postgresql --values values.yaml > manifest.yaml
```

## Install the chart

```bash
helm install postgresql bitnami/postgresql --values values.yaml --namespace examples
```

## Uninstall the chart

```bash
helm uninstall postgresql --namespace examples
```
