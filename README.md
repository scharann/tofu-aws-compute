# OpenTofu AWS Compute (Isolated State Architecture)

## Purpose & Problem Solved
This repository provisions an EC2 instance and security group in `ap-southeast-2` using its own **isolated S3 state key** (`compute/terraform.tfstate`) while reading network IDs read-only from `tofu-aws-network` via `data.terraform_remote_state.network`.

**The Problem Solved:**
Keeping compute state in `compute/terraform.tfstate` and network state in `network/terraform.tfstate` prevents state collisions, preserves remote outputs across deployments, and allows independent lifecycle management for each repository.

## Prerequisites
1. **Remote State Backend:** The S3 bucket (`<YOUR-S3-BUCKET-NAME>`) and DynamoDB lock table (`tofu-lab-locks`) must exist in `ap-southeast-2` (see `tofu-aws-network` README for creation commands).
2. **Network Stack Deployed:** `tofu-aws-network` must already be applied so `network/terraform.tfstate` exists in S3 with exported `vpc_id` and `public_subnet_ids` outputs.

## Architecture & State Configuration
- **Region:** `ap-southeast-2`
- **Backend Bucket:** `<YOUR-S3-BUCKET-NAME>`
- **Compute State Key (Read/Write):** `compute/terraform.tfstate`
- **Network Remote State (Read-Only):** `network/terraform.tfstate`
- **Lock Table:** `tofu-lab-locks`

## How to Deploy (Step 2)
1. Authenticate your AWS SSO session (`aws sso login` and `export AWS_PROFILE=<YOUR-PROFILE>`).
2. Initialize and apply the compute layer:
~~~bash
tofu init
tofu plan
tofu apply
~~~

## How to Verify Deployment
- **Check state objects:** Run `tofu state list` — confirms only `aws_security_group.ec2_sg`, `aws_instance.web`, and `data.terraform_remote_state.network` are tracked (without touching network resources).
- **Check EC2 instance in AWS:** Run `tofu output` and verify the instance is running in `ap-southeast-2` inside the VPC created by `tofu-aws-network`.

## How to Clean Up Resources
1. Destroy the compute resources before destroying `tofu-aws-network`:
~~~bash
tofu destroy
~~~
2. **Verify cleanup:**
   - Run `tofu state list` — returns zero managed resources.
   - Run `aws ec2 describe-instances --region ap-southeast-2` — confirms the instance is terminated.
