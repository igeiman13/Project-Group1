Overview:

In this lab, we will deploy multi tier environment in AWS using Terraform. The architecture contains three VPC, Prod, Dev and Staging. 
The VPC contains Bastion host which will be used as a Jumphost to access servers in NonProd and Prod VPC securely. 

Terraform Provider:AWS 
Terraform Version: 3.74.0

AWS resources created using Terraform:

S3 bucket
VPC
Subnets
Route table
NAT Gateway
Internet Gateway
EC2 instance
ALB
ASG

Pre-requisites:

Create three S3 buckets named "prod-group1-acsproject", "dev-group1-acsproject" and "staging-group1-acsproject" to store terraform state remotely. The S3 bucket names should be gloablly unique.
Create a S3 bucket for website files.
Create SSH keys using SSH-Key gen command under the webserver directory. 
Commands used : ssh-keygen -t rsa -C "Group1-project-dev" -f Group1-project-dev


Initializing Terraform

Use below command to initilize the working directory containing Terraform configuration files. This will make your current working directory updated with the changes. 

"terraform init"

Validating Terraform

Use the below command to check for any errors in the Terraform code. The code has to be validated before deploying.

"terraform validate"

Running Terraform

Use the below command to deploy the terraform configuration. 

"terraform plan" - Gives the detailed plan of actual implementation.
"terraform apply"- Applies configuration to the AWS cloud. 

Destroying Terraform

Use the below command to destroy the configurations made by Terraform. This will use the terraform state to validates the existing configuration and destroy it.

"terraform plan" - Gives the detailed plan of actual destruction. 
"terraform destroy" - Destroy the existing environment. Use the command to cleanup the environment.

Required outputs dependencies: 

public_subnet_ids
private_subnet_ids
vpc_id
public_subnet_cidrs
private_route_table
public_route_table
private_subnet_cidrs
prod_vpc_cidr

Required module dependencies:
vpc-dev
vpc-prod
vpc-staging
globalvars


Steps to follow :

Create Prod, Dev, staging S3 buckets to store the terraform state
On each VPC,
Deploy network 
Create key pair
Deploy  Webservers











