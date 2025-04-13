# Objective
Build the following architecture:
![Topology](topology.png)

# Prerequisites
## Step 1: Create S3 Buckets
Set up S3 buckets to store the Terraform state files and the image used by the web servers.

The Terraform state is stored in a bucket called `acs730-final-nh` in this project. You can use any globally unique name and update the value in the `backend.tf` files located under `staging/aws_network` and `prod/aws_network`. The buckets are already set in a way that the remote file of different environments is saved under different folders.

Another bucket named `ansibleprojectassets` has been created for this project. The `ansible_terraform.jpeg` image located under the `assets` folder has been uploaded to that bucket. This image will be displayed on the web servers deployed by Ansible. You can upload your own image to your own bucket and ensure you have access to it.

# Deployment Instructions
Detailed deployment instructions will be provided in a future update.

## Deploy the Network Infrastructure
1. Navigate to the `<environmentName>/aws_network` directory.
2. Initialize Terraform with the command: `terraform init`.
3. Deploy the network infrastructure by running: `terraform apply`.

## Generate a Key Pair for Web Servers
1. Navigate to the `<environmentName>/aws_webservers` directory.
2. Create a key pair named `nh` in the `aws_webservers` folder using the command: `ssh-keygen -t rsa -f nh`.
3. Initialize Terraform with the command: `terraform init`.
4. Deploy the web server infrastructure by running: `terraform apply`.

# Clean Up Instructions
## Destroy the Infrastructure
Detailed instructions will be provided in a future update.

## Clean Your Workspace
1. Delete the S3 bucket used to store the Terraform remote state files.
2. Delete the S3 bucket containing the image displayed on the web servers if relevant.
