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

1. S3 Buckets should be created. 
    - Total of 3 Buckets needs to be created. 
    - Name of the buckets will be : "prod-group1-acsproject", "dev-group1-acsproject" and "staging-group1-acsproject"

2. SSH Keys should be generated for each environment.
    - Command to generate ssh key : ssh-keygen -t rsa -f "keyname"
    - Keys should be created in the webserver folder of the each environment.
    - Here we need total of 3 keys for 3 different enviroment.
    - Key Names will be  : "Group1-project-dev", "Group1-project-prod" and "Group1-project-staging"


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


**********************************************************************************************************************************************************************

STEPS:

1. Change directory to /modules/globalvar/ and perform terraform apply.
2.  Now, change to direcotory of dev.
3.  Again change directory to network and perform  - terraform init
                                                   - terraform fmt
                                                   - terraform validate
                                                   - terraform plan
                                                   - terraform apply

4. Performing the above actions will create network remote state in the mentioned S3 Bucket. (config.tf)
5. Now change directory to /webserver. Generate ssh-key.
6. Then,                                  Perform  - terraform init
                                                   - terraform fmt
                                                   - terraform validate
                                                   - terraform plan
                                                   - terraform apply
                                                
7. To deploy prod, change directory to prod.
8. Repeat Steps 3 to 6.
9. To deploy staging, change directory to staging.
10. Repeat Step 3 to 6.


********************************************************************************************************************************************************************







