# About
Applying deployment automation, configuration management, and source control tools to create a two-tier static web application.

# Objective
Build the following architecture:
![Topology](topology.png)

# Deployment Instructions
Detailed deployment instructions will be provided in a future update.

## Step 1: Create S3 Buckets
Set up S3 buckets to store the Terraform state files and the image used by the web servers.
In this project the terraform state are saved in a bucket called `acs730-final-nh` as specified in the `backend.tf` files.

## Step 2: Deploy the Network Infrastructure
1. Navigate to the `<environmentName>/aws_network` directory.
2. Initialize Terraform with the command: `terraform init`.
3. Deploy the network infrastructure by running: `terraform apply`.

## Step 3: Generate a Key Pair for Web Servers
1. Navigate to the `<environmentName>/aws_webservers` directory.
2. Create a key pair named `nh` in the `aws_webservers` folder using the command: `ssh-keygen -t rsa -f nh`.
3. Initialize Terraform with the command: `terraform init`.
4. Deploy the web server infrastructure by running: `terraform apply`.
