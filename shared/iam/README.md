## IAM  
In IAM we will be creating below listed resources for different environments.

IAM Polices:
-non-prod-aspen-jenkins-policy 
-non-prod-aspen-ssm-parameter-policy


IAM Roles:
-non-prod-aspen-ssm-role
-non-prod-aspen-jenkins-role


Attaced policy with specific role.

## Pre-Requisites
    Before using this repo, ensure you have the following in place
    Configure Git, AWS CLI & Terraform must be installed on your system.

## Usage:
For creating any infra components, execute the following commands

    
    $ cd /shared/iam
    $ bash launch.sh



(launch.sh will perform terraform init, terraform plan, terraform apply and will create the workspace if not exits)