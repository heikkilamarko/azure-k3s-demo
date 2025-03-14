# Examples

## Prerequisites

Create the Kubernetes namespace where the examples will be deployed:

```bash
kubectl apply -f namespace.yaml
```

## Web App

```bash
kubectl apply -f web-app.yaml
```

```bash
sudo sh -c 'echo "$(terraform -chdir=../infra output -raw vm_public_ip) web-app.com" >> /etc/hosts'
```

```bash
curl -k https://web-app.com
```

```bash
kubectl delete -f web-app.yaml
```

```bash
sudo sed -i '' '/web-app.com/d' /etc/hosts
```

## Web App (Let's Encrypt)

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```

```bash
export ACME_EMAIL="__CHANGE_ME__"
export INGRESS_HOST="__CHANGE_ME__"
```

```text
Create a DNS A record for the domain ($INGRESS_HOST) that points to the public IP address of the VM.
```

```bash
envsubst < web-app-letsencrypt.yaml | kubectl apply -f -
```

```bash
curl -k "https://$INGRESS_HOST"
```

```bash
envsubst < web-app-letsencrypt.yaml | kubectl delete -f -
```

## Web App (Let's Encrypt with GoDaddy)

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
```

```bash
helm repo add godaddy-webhook https://snowdrop.github.io/godaddy-webhook
helm install acme-webhook godaddy-webhook/godaddy-webhook -n cert-manager --set groupName=acme.$INGRESS_HOST
```

```bash
export ACME_EMAIL="__CHANGE_ME__"
export INGRESS_HOST="__CHANGE_ME__"
export GODADDY_APIKEY="__CHANGE_ME__"
```

```text
Create a DNS A record for the domain ($INGRESS_HOST) that points to the public IP address of the VM.
```

```bash
envsubst < web-app-letsencrypt-godaddy.yaml | kubectl apply -f -
```

```bash
curl -k "https://www.$INGRESS_HOST"
```

```bash
envsubst < web-app-letsencrypt-godaddy.yaml | kubectl delete -f -
```

## NATS Server

```bash
kubectl apply -f nats-server.yaml
```

```bash
kubectl delete -f nats-server.yaml
```

## Cron Job

```bash
kubectl apply -f cron-job.yaml
```

```bash
kubectl delete -f cron-job.yaml
```

## Host Access

```bash
kubectl apply -f host-access.yaml
```

```bash
kubectl delete -f host-access.yaml
```
