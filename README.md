# 3-Tier AWS Infrastructure with Terraform

This project provisions a basic 3-tier AWS infrastructure using Terraform.  
It includes a VPC, subnets, Internet Gateway, NAT Gateway, route tables, security groups, and a Bastion EC2 instance.  
Everything is configured to run in AWS.

---
```

## 📂 Project Structure
.
├── Dynamodb.tf         # DynamoDB table for state locking
├── backend.tf          # Remote state config (S3 + DynamoDB), NAT, route tables
├── ec2.tf              # Bastion EC2 instance in public subnet, Bastion, Web, App, DB
├── outputs.tf          # Outputs (VPC ID, Bastion IP, SGs, etc.)
├── provider.tf         # Provider configuration (AWS region, credentials, etc.)
├── security_grp.tf  # Security groups
├── variables.tf        # Input variables
└── vpc.tf              # VPC, subnets, IGW

```
---


## ⚙️ Prerequisites

1. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)  
2. Configure AWS CLI:
   ```bash
   aws configure
   ```
3. (Optional) Create S3 bucket and DynamoDB table for state management.  
   If not, the Terraform code will create them for you.

---

## 🚀 How to Run

1. Clone this repo:
   ```bash
   git clone <your-repo-url>
   cd <repo-folder>
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Validate:
   ```bash
   terraform validate
   ```

4. Plan:
   ```bash
   terraform plan
   ```

5. Apply:
   ```bash
   terraform apply -auto-approve
   ```

6. Destroy when done:
   ```bash
   terraform destroy -auto-approve
   ```

---

## 🔑 Notes

- **AMI ID** → Update inside `ec2.tf` before applying.  
  Use the latest Amazon Linux 2 AMI for your region. 
  Example command:
  ```bash
  aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
    --query "Images[*].[ImageId,Name]" \
    --region ap-south-1 \
    --output table
  ```

- **Key Pair** → Use your own AWS key pair for the Bastion EC2 instance.  
  Update in `ec2.tf`:
  ```hcl
  key_name = "<your-key-name>"
  ```

  - This setup is only networking + Bastion EC2, safe for free-tier.

---


## 📌 DynamoDB for State Locking

Terraform uses DynamoDB to store state/simultaneous updates.  

This table ensures only one `terraform apply` runs at a time.

---

## 📤 Outputs

After apply, you will see:

- **Bastion Host Public IP**
- **nat_ip**

---

## 🧹 Cleanup

When done, destroy all resources:
```bash
terraform destroy -auto-approve
```
This avoids any extra AWS costs.

---

✅ With this setup, anyone checking your repo can **clone → add AMI ID + key → run terraform → get Bastion EC2 + infra** like a real project.
