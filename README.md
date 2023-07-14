# Security

Security tooling.

## Tasks

### build

```sh
podman build -t localhost/cicd-security:latest .
```

### login-to-aad

First, we need to login to Azure CLI.

```sh
az login --use-device-code
```

### list-azure-subscriptions

List the Azure subscriptions your account is subscribed to.

```
az account list -o table --query [].name -o tsv
```

### switch-azure-context

Inputs: SUBSCRIPTION_NAME

Then use the correct subscription, e.g. dev, pre-prod or prod.

```
az account set --subscription $SUBSCRIPTION_NAME

```

### list-acr

List the Azure Container Registries in the Azure subscription.

```
az acr list -o table --query [].name -o tsv
```

### login-to-acr

Inputs: REGISTRY_NAME

Get the cicd container, and copy it to Azure Continer Registry. View container registries at https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.ContainerRegistry%2Fregistries

We have 3 environments, e.g. dev-uks-aks-001, and in each environment, there's a container registry, e.g. devukacr.

```sh
az acr login --name $REGISTRY_NAME --expose-token \
    | jq -r '.accessToken' \
    | podman login $REGISTRY_NAME.azurecr.io \
      --username 00000000-0000-0000-0000-000000000000 \
      --password-stdin
```

### tag

Inputs: REGISTRY_NAME

Need to re-tag the localhost/cicd-security image with the ACR name.

```sh
podman tag localhost/cicd-security:latest $REGISTRY_NAME.azurecr.io/cicd-security:latest
```

### push

Inputs: REGISTRY_NAME

Then we can push to Azure.

```sh
podman push $REGISTRY_NAME.azurecr.io/cicd-security:latest
```
