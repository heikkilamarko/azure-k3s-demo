# Example API

Copy the Caddy install script to the VM:

```bash
scp caddy-install.sh azureuser@$(terraform -chdir=../../../infra output -raw vm_public_ip):/home/azureuser/caddy-install.sh
```

SSH into the VM:

```bash
ssh azureuser@$(terraform -chdir=../../../infra output -raw vm_public_ip)
```

Navigate to the script location:

```bash
cd /home/azureuser
```

Run the installation script:

```bash
./caddy-install.sh
```

Launch the example API endpoint with Caddy, listening on port 8080:

```bash
caddy respond --listen :8000 "example api on port {{ .Port }}"
```
