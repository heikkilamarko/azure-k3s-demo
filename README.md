# Azure K3s Demo

## Generate SSH key

```bash
ssh-keygen -t rsa -b 4096
```

## Create Azure resources with Terraform

```bash
terraform init
```

```bash
terraform apply
```

## Connect to the VM

```bash
ssh azureuser@$(terraform output -raw vm_public_ip)
```

### Verify K3s installation by listing nodes

```bash
sudo kubectl get nodes
```

### Exit the VM

```bash
exit
```

## Copy K3s configuration file to local machine

```bash
scp azureuser@$(terraform output -raw vm_public_ip):/etc/rancher/k3s/k3s.yaml /path/to/k3s.yaml
```

## Set `KUBECONFIG` environment variable

```bash
export KUBECONFIG=/path/to/k3s.yaml
```

## Set up SSH tunnel for K3s API access

```bash
ssh -L 6443:127.0.0.1:6443 azureuser@$(terraform output -raw vm_public_ip) -N
```

## Add `k3sdemo.com` to `/etc/hosts`

```bash
sudo sh -c 'echo "$(terraform output -raw vm_public_ip) k3sdemo.com" >> /etc/hosts'
```

## Deploy the demo application

```bash
kubectl apply -f demo-app.yaml
```

## Test the demo application

```bash
curl -k https://k3sdemo.com
```

## Clean up Azure resources

```bash
terraform destroy
```

## Clean up host entries

```bash
sudo sed -i '' '/k3sdemo.com/d' /etc/hosts
```
