# Traefik

The CUE schema is generated via these commands:
- `wget https://raw.githubusercontent.com/traefik/traefik/v2.9.1/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml`
- `wget https://raw.githubusercontent.com/traefik/traefik/v2.9.1/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml`
- `cue import kubernetes-crd-definition-v1.yml -l kind -l metadata.name -p k8s -f`
- `cue import kubernetes-crd-rbac.yml -l kind -l metadata.name -p k8s -f`
- `rm kubernetes-crd-definition-v1.yml kubernetes-crd-rbac.yml`
