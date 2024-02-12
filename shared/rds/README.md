## rds
In rds we will be creating below listed resources for different environments.

RDS cluster:

non-prod-aspen-mysql-wlqo6t


## Pre-Requisites
    Before using this repo, ensure you have the following in place
    Configure Git, AWS CLI & Terraform must be installed on your system.

## Usage:
For creating any infra components, execute the following commands

    
    $ cd /shared/rds
    $ bash launch.sh



(launch.sh will perform terraform init, terraform plan, terraform apply and will create the workspace if not exits)