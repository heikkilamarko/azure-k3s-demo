# Web App

## Web App

```bash
kubectl apply -f web-app.yaml
```

```bash
kubectl delete -f web-app.yaml
```

## Ingress Examples

### Traefik Default Certificate

```bash
sudo sh -c 'echo "$(terraform -chdir=../../infra output -raw vm_public_ip) web-app.test" >> /etc/hosts'
```

```bash
kubectl apply -f web-app-ingress.yaml
```

```bash
curl -k https://web-app.test
```

```bash
kubectl delete -f web-app-ingress.yaml
```

```bash
sudo sed -i '' '/web-app.test/d' /etc/hosts
```

### Let's Encrypt Certificate

Prerequisites:

- Refer to the [cert-manager](../cert-manager) example.

- Create a DNS A record for the domain `$DOMAIN` pointing to the public IP address of the VM.

```bash
envsubst < web-app-ingress-letsencrypt.yaml | kubectl apply -f -
```

```bash
curl -k "https://$DOMAIN"
```

```bash
envsubst < web-app-ingress-letsencrypt.yaml | kubectl delete -f -
```

### Let's Encrypt Certificate with Cloudflare DNS

Prerequisites:

- Refer to the [cert-manager](../cert-manager) example.

- Create a DNS A record for the domain `$DOMAIN` pointing to the public IP address of the VM.

```bash
envsubst < web-app-ingress-letsencrypt-cloudflare.yaml | kubectl apply -f -
```

```bash
curl -k "https://web-app.$DOMAIN"
```

```bash
envsubst < web-app-ingress-letsencrypt-cloudflare.yaml | kubectl delete -f -
```
