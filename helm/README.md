# Helm Template Dump Commands

## Dump all templates with default values
```bash
helm template nginx-app ./nginx-app
```

## Dump templates with custom values file
```bash
helm template nginx-app ./nginx-app -f nginx-app/values.yaml
```

## Dump to file
```bash
helm template nginx-app ./nginx-app > manifests.yaml
```

## Dump specific template only
```bash
# Deployment only
helm template nginx-app ./nginx-app --show-only templates/deployment.yaml

# Ingress only
helm template nginx-app ./nginx-app --show-only templates/ingress.yaml
```

## Dump with debug information
```bash
helm template nginx-app ./nginx-app --debug