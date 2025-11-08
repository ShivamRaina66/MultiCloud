# BankPro Multi-Cloud CI/CD Demo

This package contains a ready-to-run demo for deploying a Spring Boot microservice to AWS & Azure VMs using:
- Jenkins (hosted on a provisioned VM)
- Docker (images pushed to Docker Hub)
- Ansible for deployment
- Terraform to provision VMs (AWS & Azure)

**What is included**
- `springboot-app/` — minimal Spring Boot app (Maven)
- `Dockerfile` — to build the image
- `Jenkinsfile` — declarative pipeline that builds, pushes, and triggers Ansible
- `ansible/` — inventories, playbooks and roles
- `terraform/aws/` and `terraform/azure/` — Terraform to create 1 VM per cloud
- `scripts/setup-jenkins.sh` — bootstrap script for Jenkins VM
- `README.md` — this file

**Before you begin**
1. Install Terraform (https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Install AWS CLI and configure `aws configure`.
3. Install Azure CLI and run `az login`.
4. Ensure you have an SSH key pair (`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`).
5. Create a Docker Hub account and note your username and repository.

**Quick steps (high level)**
1. Provision VMs:
   - `cd terraform/aws && terraform init && terraform apply -auto-approve`
   - `cd terraform/azure && terraform init && terraform apply -auto-approve`
   - Note public IPs printed by Terraform.

2. Update `ansible/inventories/multi-cloud` with the public IPs and SSH key locations.

3. On one VM (recommended AWS), run `scripts/setup-jenkins.sh` to install Jenkins, Docker, and Ansible.

4. In Jenkins:
   - Install required plugins (Git, Pipeline, Docker Pipeline, Ansible).
   - Add credentials: Docker Hub username/password under id `dockerhub-creds`.
   - Create a pipeline pointing to this repository (or use the `Jenkinsfile` locally).

5. Run the pipeline: it builds the Spring Boot app, runs tests, builds Docker image, pushes to Docker Hub, and calls Ansible to deploy to both VMs.

**Notes & placeholders**
- Replace `DOCKER_HUB_USER` and `DOCKER_HUB_REPO` in `Jenkinsfile` or Jenkins credentials.
- Replace `key_name` and `ssh_public_key` variables in Terraform `variables.tf` files as needed.

For detailed remediation steps and troubleshooting, follow the step-by-step section in this README's later pages (inside the zip).
