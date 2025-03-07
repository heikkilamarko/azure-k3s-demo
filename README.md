# Azure K3s Demo

## Generate SSH Key

```bash
ssh-keygen -t rsa -b 4096
```

## Create Azure Resources with Terraform

```bash
terraform -chdir=infra/shared init
```

```bash
terraform -chdir=infra/shared apply
```

## Verify K3s Installation

### 1. Connect to the VM

```bash
ssh azureuser@$(terraform -chdir=infra/shared output -raw vm_public_ip)
```

### 2. List the K3s Nodes

```bash
sudo kubectl get nodes
```

## Establish an SSH Tunnel for K3s API Access

### 1. Copy the K3s Config File

```bash
scp azureuser@$(terraform -chdir=infra/shared output -raw vm_public_ip):/etc/rancher/k3s/k3s.yaml /path/to/k3s.yaml
```

### 2. Set the `KUBECONFIG` Environment Variable

```bash
export KUBECONFIG="/path/to/k3s.yaml"
```

### 3. Create an SSH Tunnel

```bash
ssh -L 6443:127.0.0.1:6443 azureuser@$(terraform -chdir=infra/shared output -raw vm_public_ip) -N
```

## Deploy the Demo Services

### Web App

```bash
kubectl apply -f k8s/web-app.yaml
```

```bash
sudo sh -c 'echo "$(terraform -chdir=infra/shared output -raw vm_public_ip) web-app.com" >> /etc/hosts'
```

```bash
curl -k https://web-app.com
```

```bash
kubectl delete -f k8s/web-app.yaml
```

```bash
sudo sed -i '' '/web-app.com/d' /etc/hosts
```

### Web App (Let's Encrypt)

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
cat k8s/web-app-letsencrypt.yaml | envsubst | kubectl apply -f -
```

```bash
curl -k "https://$INGRESS_HOST"
```

```bash
cat k8s/web-app-letsencrypt.yaml | envsubst | kubectl delete -f -
```

### Web App (Let's Encrypt with GoDaddy)

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
cat k8s/web-app-letsencrypt-godaddy.yaml | envsubst | kubectl apply -f -
```

```bash
curl -k "https://www.$INGRESS_HOST"
```

```bash
cat k8s/web-app-letsencrypt-godaddy.yaml | envsubst | kubectl delete -f -
```

### NATS Server

```bash
kubectl apply -f k8s/nats-server.yaml
```

```bash
kubectl delete -f k8s/nats-server.yaml
```

## Clean Up Azure Resources

```bash
terraform -chdir=infra/shared destroy
```
