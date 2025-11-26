# Terraform AWS Infrastructure Documentation

This document provides a comprehensive overview of the Terraform code used to provision a scalable and resilient AWS infrastructure. The infrastructure is designed to host a web application with high availability, security, and observability.

## Table of Contents

- [Project Structure](#project-structure)
- [Root Module](#root-module)
- [Modules](#modules)
  - [Networking](#networking)
  - [Security](#security)
  - [CloudWatch](#cloudwatch)
  - [EC2](#ec2)
  - [ACM](#acm)
  - [Route53](#route53)
  - [ALB](#alb)
- [How It Works](#how-it-works)
- [How to Use](#how-to-use)

## Project Structure

The project is organized into a root module and several child modules, each responsible for a specific component of the infrastructure.

```
.
├── main.tf
├── outputs.tf
├── provider.tf
├── terraform.tfstate
├── terraform.tfstate.backup
├── variables.tf
└── modules/
    ├── acm/
    ├── alb/
    ├── cloudwatch/
    ├── ec2/
    ├── networking/
    ├── route53/
    └── security/
```

## Root Module

The root module (`main.tf`) is the entry point for the Terraform configuration. It instantiates all the child modules and passes the required variables to them.

### `main.tf`

- **`networking` module:** Creates the VPC, subnets, internet gateway, NAT gateway, and route tables.
- **`security` module:** Creates security groups for the ALB and EC2 instances.
- **`cloudwatch` module:** Creates an IAM role and instance profile for CloudWatch agent.
- **`ec2` module:** Creates two EC2 instances in private subnets.
- **`acm` module:** Creates an ACM certificate for the domain.
- **`route53` module:** Creates Route53 records for the ALB and for domain validation.
- **`alb` module:** Creates an Application Load Balancer, target groups, and listeners.

### `variables.tf`

Defines the input variables for the root module, such as `vpc_cidr`, `ami_id`, `instance_type`, `domain_name`, and `zone_id`.

### `outputs.tf`

Defines the output variables for the root module, such as the `alb_dns_name`.

## Modules

### Networking

The `networking` module is responsible for creating the network infrastructure.

- **`main.tf`:** Creates a VPC, public and private subnets in two availability zones, an internet gateway, a NAT gateway, and public and private route tables.
- **`variables.tf`:** Defines the `vpc_cidr` input variable.
- **`outputs.tf`:** Outputs the VPC ID and subnet IDs.

### Security

The `security` module creates the security groups for the infrastructure.

- **`main.tf`:** Creates two security groups:
    - `alb_sg`: Allows inbound HTTP and HTTPS traffic from anywhere.
    - `ec2_sg`: Allows inbound HTTP and a custom port (8081) from the ALB security group.
- **`variables.tf`:** Defines the `vpc_id` input variable.
- **`outputs.tf`:** Outputs the IDs of the created security groups.

### CloudWatch

The `cloudwatch` module sets up the necessary IAM resources for the CloudWatch agent.

- **`main.tf`:** Creates an IAM role (`ec2_cloudwatch_role`) and an IAM instance profile (`ec2_cloudwatch_instance_profile`) with the `CloudWatchAgentServerPolicy` attached.
- **`config.json`:**  A configuration file for the CloudWatch agent to collect memory usage and NGINX access logs.
- **`outputs.tf`:** Outputs the instance profile name and the content of the `config.json` file.

### EC2

The `ec2` module creates two EC2 instances.

- **`main.tf`:** Creates two EC2 instances (`web1` and `web2`) in private subnets. The instances are associated with the IAM instance profile created in the `cloudwatch` module and have user data scripts to install and configure NGINX, Docker, and the CloudWatch agent.
- **`user_data_web1.sh` & `user_data_web2.sh`:** These scripts are executed on the EC2 instances at launch. They:
    - Install NGINX and Docker.
    - Install and configure the CloudWatch agent.
    - Run a Docker container with a simple "Namaste" application.
    - Configure NGINX as a reverse proxy to the Docker container and also to serve a simple message from the instance itself.
- **`variables.tf`:** Defines input variables for AMI ID, instance type, subnet IDs, security group ID, domain name, instance profile name, and CloudWatch agent configuration.
- **`outputs.tf`:** Outputs the instance IDs of the created EC2 instances.

### ACM

The `acm` module creates an SSL certificate for the domain.

- **`main.tf`:** Creates an ACM certificate for `*.testpagespage.space` with DNS validation.
- **`variables.tf`:** Defines the `validation_record_fqdns` input variable.
- **`outputs.tf`:** Outputs the ACM certificate ARN and the domain validation options.

### Route53

The `route53` module manages the DNS records for the domain.

- **`main.tf`:**
    - Creates DNS records for ACM certificate validation.
    - Creates A records for the ALB and various subdomains to point to the ALB.
- **`variables.tf`:** Defines input variables for the domain name, zone ID, ALB DNS name, ALB zone ID, and domain validation options.
- **`outputs.tf`:** Outputs the FQDNs of the validation records.

### ALB

The `alb` module creates an Application Load Balancer.

- **`main.tf`:**
    - Creates an ALB.
    - Creates multiple target groups for routing traffic to the EC2 instances and Docker containers.
    - Creates listeners for HTTP (redirects to HTTPS) and HTTPS.
    - Creates listener rules for host-based routing to different target groups.
- **`variables.tf`:** Defines input variables for VPC ID, subnet IDs, security group ID, EC2 instance IDs, domain name, and ACM certificate ARN.
- **`outputs.tf`:** Outputs the DNS name and zone ID of the ALB.

## How It Works

1.  The `networking` module sets up the VPC and subnets.
2.  The `security` module creates security groups to control traffic.
3.  The `cloudwatch` module prepares the IAM role for monitoring.
4.  The `ec2` module launches two EC2 instances in private subnets. These instances are bootstrapped with user data to install NGINX, Docker, and the CloudWatch agent.
5.  The `acm` module requests an SSL certificate.
6.  The `route53` module creates the necessary DNS records to validate the certificate and to point the domain to the ALB.
7.  The `alb` module creates an ALB that listens on HTTP and HTTPS. It routes traffic based on the hostname to different target groups, which in turn forward the traffic to the NGINX server on the EC2 instances. The NGINX server then either serves a static page or reverse proxies to a Docker container.

## How to Use

1.  **Prerequisites:**
    - Terraform installed.
    - AWS account with credentials configured.
    - A registered domain with a hosted zone in Route 53.

2.  **Configuration:**
    - Update the `variables.tf` file in the root directory with your specific values for `domain_name` and `zone_id`.
    - You might need to update the `ami_id` in `variables.tf` to a current one for your region.

3.  **Deployment:**
    ```bash
    terraform init
    terraform plan
    terraform apply
    ```

4.  **Accessing the application:**
    Once the infrastructure is provisioned, you can access the application using the DNS name of the ALB, which is provided as an output. You can also use the domain names configured in the `route53` module.
