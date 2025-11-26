# Infrastructure Documentation

This document details the infrastructure setup, configurations, and endpoint URLs for the Terraform script in this repository.

## Overview

The Terraform script provisions a highly available and scalable web application infrastructure on AWS. The architecture consists of a 2-tier setup with a public-facing Application Load Balancer (ALB) and a backend fleet of EC2 instances in private subnets. The infrastructure is defined in a modular way, with separate modules for networking, security, EC2, and other components.

## Infrastructure Components

### Networking

The `networking` module creates the following resources:

-   **VPC:** A Virtual Private Cloud with a user-defined CIDR block.
-   **Subnets:**
    -   Two public subnets for the Application Load Balancer.
    -   Two private subnets for the EC2 instances.
-   **Internet Gateway:** To provide internet access to the public subnets.
-   **NAT Gateway:** To allow instances in the private subnets to access the internet for software updates.
-   **Route Tables:**
    -   A public route table that directs traffic to the Internet Gateway.
    -   A private route table that directs traffic to the NAT Gateway.

### Security

The `security` module defines the following security groups:

-   **ALB Security Group:**
    -   Allows inbound traffic on port 80 (HTTP) and 443 (HTTPS) from the internet.
    -   Allows all outbound traffic.
-   **EC2 Security Group:**
    -   Allows inbound traffic on port 80 (HTTP) and 8081 from the ALB.
    -   Allows all outbound traffic.

### EC2 Instances

The `ec2` module provisions two EC2 instances, `web1` and `web2`, in the private subnets. Each instance is configured with a user data script that:

-   Installs NGINX, Docker, and the CloudWatch Agent.
-   Runs a Docker container with a simple web application on port 8081.
-   Configures NGINX as a reverse proxy to serve a static page on port 80 and to proxy requests to the Docker container.

### Application Load Balancer (ALB)

The `alb` module creates an Application Load Balancer with the following configuration:

-   **Listeners:**
    -   An HTTP listener on port 80 that redirects all traffic to HTTPS.
    -   An HTTPS listener on port 443 that uses a wildcard SSL certificate.
-   **Target Groups:**
    -   Multiple target groups for routing traffic to the EC2 instances based on the hostname.
-   **Routing Rules:**
    -   Host-based routing rules on the HTTPS listener to direct traffic to different backend services (either the NGINX on the instance or the Docker container).

### DNS and SSL

-   **ACM:** The `acm` module requests a wildcard SSL certificate for `*.testpagespage.space`.
-   **Route 53:** The `route53` module creates the necessary DNS records to validate the SSL certificate and to point the various subdomains to the ALB.

### CloudWatch

The `cloudwatch` module configures the CloudWatch agent on the EC2 instances to collect and send logs and metrics to CloudWatch. The following is collected:

-   **Metrics:**
    -   `mem_used_percent`
-   **Logs:**
    -   `/var/log/nginx/access.log`
    -   `/var/log/syslog`

## Configuration

The infrastructure is configured using variables defined in `variables.tf`. The following variables can be customized:

-   `vpc_cidr`: The CIDR block for the VPC.
-   `ami_id`: The ID of the AMI to use for the EC2 instances.
-   `instance_type`: The instance type for the EC2 instances.
-   `domain_name`: The domain name to use for the application.
-   `zone_id`: The ID of the Route 53 hosted zone.

## Endpoint URLs

Once the infrastructure is provisioned, the following endpoint URLs will be available:

-   `https://ec2-alb-docker.<domain_name>`: This URL will route traffic to the Docker containers running on the EC2 instances.
-   `https://ec2-alb-instance.<domain_name>`: This URL will route traffic to the NGINX web server running on the EC2 instances.
-   `https://ec2-docker1.<domain_name>`: This URL will route traffic to the Docker container on the `web1` instance.
-   `https://ec2-docker2.<domain_name>`: This URL will route traffic to the Docker container on the `web2` instance.
-   `https://ec2-instance1.<domain_name>`: This URL will route traffic to the NGINX web server on the `web1` instance.
-   `https://ec2-instance2.<domain_name>`: This URL will route traffic to the NGINX web server on the `web2` instance.

Note: You will need to replace `<domain_name>` with the actual domain name you configured in the `variables.tf` file.
