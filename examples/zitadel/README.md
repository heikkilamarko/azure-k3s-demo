# ZITADEL Example

## Add the chart repository

```bash
helm repo add zitadel https://charts.zitadel.com
```

## Update the chart repository

```bash
helm repo update
```

## Render chart templates locally

```bash
helm template zitadel zitadel/zitadel --values values.yaml > manifest.yaml
```

## Install the chart

```bash
helm install zitadel zitadel/zitadel --values values.yaml --namespace examples
```

## Uninstall the chart

```bash
helm uninstall zitadel --namespace examples
```
