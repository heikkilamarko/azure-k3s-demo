# Distribution Registry

[Official documentation](https://distribution.github.io/distribution/)

## Configure Docker for Insecure Registries

If the registry uses an HTTPS certificate that is not trusted by Docker (for example, a self-signed or internal CA certificate), Docker rejects connections due to TLS verification errors. To prevent this, add the registry domain to Docker’s list of insecure registries by adding or updating the `insecure-registries` entry in the Docker daemon configuration file:

```json
{
  "insecure-registries": ["registry.test"]
}
```

## Add Registry Domain to `/etc/hosts`

```bash
sudo sh -c 'echo "$(terraform -chdir=../../infra output -raw vm_public_ip) registry.test" >> /etc/hosts'
```

## Generate `htpasswd` for Registry Authentication

```bash
htpasswd -Bbn "$(terraform -chdir=../../infra output -raw container_registry_username)" "$(terraform -chdir=../../infra output -raw container_registry_password)" > htpasswd
```

## Create Kubernetes Secret

```bash
kubectl create secret generic distribution --from-file=htpasswd=htpasswd --namespace examples
```

## Deploy the Container Registry

```bash
kubectl apply -f distribution.yaml
```

## Pull, Tag, and Push an Image

```bash
docker pull --platform linux/amd64 nginx
```

```bash
docker tag nginx registry.test/nginx
```

```bash
docker login \
    --username "$(terraform -chdir=../../infra output -raw container_registry_username)" \
    --password "$(terraform -chdir=../../infra output -raw container_registry_password)" \
    registry.test
```

```bash
docker push registry.test/nginx
```

## Registry HTTP API

[HTTP API V2](https://distribution.github.io/distribution/spec/api/)

[Listing Repositories](https://distribution.github.io/distribution/spec/api/#listing-repositories)

```bash
curl -k -L -u "$(terraform -chdir=../../infra output -raw container_registry_username):$(terraform -chdir=../../infra output -raw container_registry_password)" \
    https://registry.test/v2/_catalog
```

[Listing Image Tags](https://distribution.github.io/distribution/spec/api/#listing-image-tags)

```bash
curl -k -L -u "$(terraform -chdir=../../infra output -raw container_registry_username):$(terraform -chdir=../../infra output -raw container_registry_password)" \
    https://registry.test/v2/nginx/tags/list
```

[Existing Manifests](https://distribution.github.io/distribution/spec/api/#existing-manifests)

```bash
curl -k -L -I -u "$(terraform -chdir=../../infra output -raw container_registry_username):$(terraform -chdir=../../infra output -raw container_registry_password)" \
    -H "Accept: application/vnd.docker.distribution.manifest.v2+json" \
    https://registry.test/v2/nginx/manifests/<tag_or_digest>
```

[Deleting an Image](https://distribution.github.io/distribution/spec/api/#deleting-an-image)

```bash
curl -k -L -u "$(terraform -chdir=../../infra output -raw container_registry_username):$(terraform -chdir=../../infra output -raw container_registry_password)" \
   -X DELETE https://registry.test/v2/nginx/manifests/<digest>
```

## Cleanup

```bash
kubectl delete -f distribution.yaml
```

```bash
kubectl delete secret distribution --namespace examples
```

```bash
sudo sed -i '' '/registry.test/d' /etc/hosts
```
