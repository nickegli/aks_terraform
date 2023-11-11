# aks_terraform
aks cluster demo for terraform

## How to use this template
All values that require configuration can be viewed inside variable.tf

!! check is done for prexisting ressource group - !!

## Connecting to Tenant and Subscription
1. run ```az login``` and follow the on screen instructions
2. check you are using the right subscription with ```az account list```
3. if the subscription is wrong switch by running ```az account set ${subscription_name}```

## Building Terraform
1. run ```terraform init -upgrade``` to download all necessary plugins (-upgrade checks if any new versions are available)
2. run ```terraform plan -out main.tfplan``` to see what changes will be applied
3. run ```terraform apply main.tfplan``` to apply changes