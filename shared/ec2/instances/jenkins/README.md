## EC2 Jenkins instance 
In Jenkins we will be creating below listed resources for different environments.

Ec2 Instances:
- non-prod-aspen-jenkins

## Pre-Requisites
    Before using this repo, ensure you have the following in place
    Configure Git, AWS CLI & Terraform must be installed on your system.

## Usage:
For creating any infra components, execute the following commands

    
    $ cd /shared/ec2/instances/jenkins
    $ bash launch.sh



(launch.sh will perform terraform init, terraform plan, terraform apply and will create the workspace if not exits)