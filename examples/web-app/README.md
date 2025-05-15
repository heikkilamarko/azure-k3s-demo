# Web App Example

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
sudo sh -c 'echo "$(terraform -chdir=../../infra output -raw vm_public_ip) web-app.local" >> /etc/hosts'
```

```bash
kubectl apply -f web-app-ingress.yaml
```

```bash
curl -k https://web-app.local
```

```bash
kubectl delete -f web-app-ingress.yaml
```

```bash
sudo sed -i '' '/web-app.local/d' /etc/hosts
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

### Let's Encrypt Certificate with GoDaddy DNS

Prerequisites:

- Refer to the [cert-manager](../cert-manager) example.

- Create a DNS A record for the domain `$DOMAIN` pointing to the public IP address of the VM.

```bash
envsubst < web-app-ingress-letsencrypt-godaddy.yaml | kubectl apply -f -
```

```bash
curl -k "https://www.$DOMAIN"
```

```bash
envsubst < web-app-ingress-letsencrypt-godaddy.yaml | kubectl delete -f -
```
