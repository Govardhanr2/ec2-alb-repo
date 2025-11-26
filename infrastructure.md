Once the infrastructure is provisioned, the following endpoint URLs will be available:                            │
│ 84                                                                                                                   │
│ 85 -   `https://ec2-alb-docker.<domain_name>`: This URL will route traffic to the Docker containers running on the   │
│    EC2 instances.                                                                                                    │
│ 86 -   `https://ec2-alb-instance.<domain_name>`: This URL will route traffic to the NGINX web server running on the  │
│    EC2 instances.                                                                                                    │
│ 87 -   `https://ec2-docker1.<domain_name>`: This URL will route traffic to the Docker container on the `web1`        │
│    instance.                                                                                                         │
│ 88 -   `https://ec2-docker2.<domain_name>`: This URL will route traffic to the Docker container on the `web2`        │
│    instance.                                                                                                         │
│ 89 -   `https://ec2-instance1.<domain_name>`: This URL will route traffic to the NGINX web server on the `web1`      │
│    instance.                                                                                                         │
│ 90 -   `https://ec2-instance2.<domain_name>`: This URL will route traffic to the NGINX web server on the `web2`      │
│    instance.                                                                                                         │
│ 91                                                                                                                   │
│ 92 Note: You will need to replace `<domain_name>` with the actual domain name you configured in the `variables.tf`   │
│    file.            
