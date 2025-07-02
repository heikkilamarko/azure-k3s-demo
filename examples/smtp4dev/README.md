# smtp4dev

## Render

```bash
kubectl kustomize ./base | envsubst
```

OR

```bash
kubectl kustomize ./overlays/letsencrypt | envsubst
```

## Deploy

```bash
kubectl kustomize ./base | envsubst | kubectl apply -f -
```

OR

```bash
kubectl kustomize ./overlays/letsencrypt | envsubst | kubectl apply -f -
```

## Clean Up

```bash
kubectl kustomize ./base | envsubst | kubectl delete -f -
```

OR

```bash
kubectl kustomize ./overlays/letsencrypt | envsubst | kubectl delete -f -
```
