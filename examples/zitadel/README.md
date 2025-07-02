# ZITADEL

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
envsubst < values.yaml | helm template zitadel zitadel/zitadel --values - > manifest.yaml
```

## Install the chart

```bash
envsubst < values.yaml | helm install zitadel zitadel/zitadel --namespace examples --values -
```

## ZITADEL Console

https://zitadel.test

| ZITADEL Admin                        | Initial Password |
| ------------------------------------ | ---------------- |
| `zitadel-admin@zitadel.zitadel.test` | `Password1!`     |

## Uninstall the chart

```bash
helm uninstall zitadel --namespace examples
```
