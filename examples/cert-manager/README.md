# cert-manager

## Environment Variables

```bash
export ACME_EMAIL="__CHANGE_ME__"
export DOMAIN="__CHANGE_ME__"
export CLOUDFLARE_API_TOKEN="__CHANGE_ME__"
```

## cert-manager

https://cert-manager.io/

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.18.2/cert-manager.yaml
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
helm install reflector emberstack/reflector -n cert-manager
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

### Let’s Encrypt Staging with Cloudflare DNS

#### Create

```bash
envsubst < letsencrypt-staging-cloudflare.yaml | kubectl apply -f -
```

```bash
envsubst < certificate-staging-cloudflare.yaml | kubectl apply -f -
```

#### Delete

```bash
envsubst < certificate-staging-cloudflare.yaml | kubectl delete -f -
```

```bash
envsubst < letsencrypt-staging-cloudflare.yaml | kubectl delete -f -
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

### Let’s Encrypt Production with Cloudflare DNS

#### Create

```bash
envsubst < letsencrypt-production-cloudflare.yaml | kubectl apply -f -
```

```bash
envsubst < certificate-production-cloudflare.yaml | kubectl apply -f -
```

#### Delete

```bash
envsubst < certificate-production-cloudflare.yaml | kubectl delete -f -
```

```bash
envsubst < letsencrypt-production-cloudflare.yaml | kubectl delete -f -
```
