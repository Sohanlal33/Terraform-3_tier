# 🚀 Terraform 3-Tier AWS Infrastructure

This repository provisions a **modular, production-ready 3-tier architecture on AWS** using **Terraform**.  
The setup includes **VPC, Subnets, Bastion Host, Web/App EC2, Auto Scaling, RDS, and ALB** — all together .

---

## 📂 Project Structure
```bash
.
├── backend.tf          # Remote state backend (S3 + DynamoDB)
├── dynamodb.tf         # DynamoDB table for state locking
├── main.tf             # Root configuration calling all modules
├── outputs.tf          # Global outputs (Bastion IP, VPC ID, etc.)
├── provider.tf         # AWS provider configuration
├── variables.tf        # Input variables (region, CIDRs, AMIs, tags)
├── userdata/           # User data scripts for EC2
│   ├── app-tier-user-data.sh
│   └── web-tier-user-data.sh
└── modules/            # Modularized Terraform resources
    ├── vpc/            # VPC, subnets, IGW, NAT, route tables
    ├── ec2/            # Bastion, Web, and App EC2 + launch templates
    ├── alb/            # Application Load Balancer + Target Groups
    ├── asg/            # Auto Scaling Groups for Web/App tiers
    ├── rds/            # RDS MySQL Database (private subnets)
    ├── iam/            # IAM roles & instance profiles
    └── s3/             # S3 bucket for state/logs/other storage



## ⚙️ Prerequisites

1. Install [Terraform](https://developer.hashicorp.com/terraform/downloads)  
2. Configure AWS CLI:
   ```bash
   aws configure
   ```
3. (Optional) Create S3 bucket and DynamoDB table for state management.  
   If not, the Terraform code will create them for you.

---
🔑 Update Before Running

You must update these variables in variables.tf

| Variable           | Description                   | Example                   |
| ------------------ | ----------------------------- | ------------------------- |
| `bastion_key_name` | SSH key pair name for Bastion | `"my-key"`                |
| `bastion_ami`      | AMI ID for Bastion host       | `"ami-0abcdef1234567890"` |
| `app_ami`          | AMI ID for App servers        | `"ami-0abcdef1234567890"` |
| `web_ami`          | AMI ID for Web servers        | `"ami-0abcdef1234567890"` |
| `rds_password`     | Master password for RDS       | `"StrongPassword123!"`    |

📌 User Data Scripts:

Update userdata/web-tier-user-data.sh for web tier setup (e.g., Nginx/Apache)

Update userdata/app-tier-user-data.sh for application tier setup (e.g., Spring Boot, Node.js)


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
📤 Outputs

After apply, Terraform will display:

✅ Bastion Host Public IP

✅ VPC ID

✅ Subnet IDs

✅ Load Balancer DNS

✅ NAT Gateway IP

✅ RDS Endpoint

6. Destroy when done:
   ```bash
   terraform destroy -auto-approve
   ```
---

## 🧹 Cleanup

When done, destroy all resources:
```bash
terraform destroy -auto-approve
```
This avoids any extra AWS costs.

---

✅ Highlights

🔒 Uses DynamoDB for state locking (safe in team environments)

📦 Modular design → reusable in other projects

🌍 Multi-tier networking (public, private-web, private-app, private-db)

📊 Scalable with Auto Scaling Groups + ALB

🛡️ Security-first: Bastion in public subnet, workloads in private

🙌 Contribution

Fork, modify, and reuse this module for your own projects.
PRs welcome to improve best practices or extend functionality.
