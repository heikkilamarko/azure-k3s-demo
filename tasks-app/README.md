# Tasks App

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

## Build

```bash
./ci.sh <docker_image_tag>
```

## Deploy

```bash
./cd.sh <docker_image_tag>
```

## Test

```bash
curl -k https://tasks-app.com/tasks
```

## Clean Up

```bash
./cleanup.sh
```

## Destroy Azure Resources

```bash
terraform -chdir=infra destroy
```
