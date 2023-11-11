# aks_terraform
aks cluster demo for terraform

## How to use this template
1. create a ressource group in azure subscription following the naming convention ${customer_name}-${environment}-rg in switzerlandnorth region.

2. when executing this terraform script you will be prompted to provide values for following variables - use the same as used when creating the ressource group.
- customer_name
- cluster_name 
- environment (tst/int/prd)

## Connecting to Tenant and Subscription
1. run ```az login``` and follow the on screen instructions
2. check you are using the right subscription with ```az account list```
3. if the subscription is wrong switch by running ```az account set ${subscription_name}```

## Building Terraform
1. run ```terraform init -upgrade``` to download all necessary plugins (-upgrade checks if any new versions are available)
2. run ```terraform plan -out main.tfplan``` to see what changes will be applied
3. run ```terraform apply main.tfplan``` to apply changes


## Using the provisioned infrastructure
!! as of now missing permissions to create role_assignment to allow aks cluster to pull images from registry !!

### Pushing to the Container Registry
To push a localy built image run the following commands
1. docker login loginserver
2. docker build . -t image:tag
3. docker image tag image:tag login-server/registry/image:tag  
4. docker push login-server/registry/image:tag    


### Retrieving from Registry

### Deploying Application to AKS Cluster
ArgoCD?


