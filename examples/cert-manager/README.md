# cert-manager

## Environment Variables

```bash
export ACME_EMAIL="__CHANGE_ME__"
export DOMAIN="__CHANGE_ME__"
export GODADDY_APIKEY="__CHANGE_ME__"
```

## cert-manager

https://cert-manager.io/

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.2/cert-manager.yaml
```

## GoDaddy Webhook

https://github.com/snowdrop/godaddy-webhook

```bash
helm repo add godaddy-webhook https://snowdrop.github.io/godaddy-webhook
```

```bash
helm install acme-webhook godaddy-webhook/godaddy-webhook -n cert-manager --set groupName=acme.$DOMAIN
```

## Reflector

[Syncing Secrets Across Namespaces](https://cert-manager.io/docs/devops-tips/syncing-secrets-across-namespaces/)

```bash
helm repo add emberstack https://emberstack.github.io/helm-charts
```

```bash
helm repo update
```

```bash
helm upgrade --install reflector emberstack/reflector
```

## Certificate Examples

### Let’s Encrypt Staging

#### Create

```bash
envsubst < letsencrypt-staging.yaml | kubectl apply -f -
```

```bash
envsubst < certificate-staging.yaml | kubectl apply -f -
```

#### Delete

```bash
envsubst < certificate-staging.yaml | kubectl delete -f -
```

```bash
envsubst < letsencrypt-staging.yaml | kubectl delete -f -
```

### Let’s Encrypt Production

#### Create

```bash
envsubst < letsencrypt-production.yaml | kubectl apply -f -
```

```bash
envsubst < certificate-production.yaml | kubectl apply -f -
```

#### Delete

```bash
envsubst < certificate-production.yaml | kubectl delete -f -
```

```bash
envsubst < letsencrypt-production.yaml | kubectl delete -f -
```

### Let’s Encrypt Staging with GoDaddy DNS

#### Create

```bash
envsubst < letsencrypt-staging-godaddy.yaml | kubectl apply -f -
```

```bash
envsubst < certificate-staging-godaddy.yaml | kubectl apply -f -
```

#### Delete

```bash
envsubst < certificate-staging-godaddy.yaml | kubectl delete -f -
```

```bash
envsubst < letsencrypt-staging-godaddy.yaml | kubectl delete -f -
```

### Let’s Encrypt Production with GoDaddy DNS

#### Create

```bash
envsubst < letsencrypt-production-godaddy.yaml | kubectl apply -f -
```

```bash
envsubst < certificate-production-godaddy.yaml | kubectl apply -f -
```

#### Delete

```bash
envsubst < certificate-production-godaddy.yaml | kubectl delete -f -
```

```bash
envsubst < letsencrypt-production-godaddy.yaml | kubectl delete -f -
```
