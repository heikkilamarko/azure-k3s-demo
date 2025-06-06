# Azure K3s Demo

## Generate SSH Key

```bash
ssh-keygen -t rsa -b 4096
```

## Create Azure Resources

### Terraform Backend Resources

```bash
terraform -chdir=infra_tf init
```

```bash
terraform -chdir=infra_tf apply
```

### Infra Resources

```bash
terraform -chdir=infra init
```

```bash
terraform -chdir=infra apply
```

## Check SSH Access to the VM

```bash
ssh azureuser@$(terraform -chdir=infra output -raw vm_public_ip)
```

## Install K3s on the VM

```bash
scripts/vm_install.sh
```

## Establish an SSH Tunnel for K3s API Access

### 1. Copy the K3s Config File

```bash
scp azureuser@$(terraform -chdir=infra output -raw vm_public_ip):/etc/rancher/k3s/k3s.yaml /path/to/k3s.yaml
```

### 2. Set the `KUBECONFIG` Environment Variable

```bash
export KUBECONFIG="/path/to/k3s.yaml"
```

### 3. Create an SSH Tunnel

```bash
ssh -L 6443:127.0.0.1:6443 azureuser@$(terraform -chdir=infra output -raw vm_public_ip) -N
```

## Destroy Azure Resources

```bash
terraform -chdir=infra destroy
```
