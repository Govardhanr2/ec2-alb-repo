#!/bin/bash
# Update and install prerequisites
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2 lsb-release


# Install Docker (official script, more robust)
curl -fsSL https://get.docker.com | sh
systemctl start docker
systemctl enable docker

# Install NGINX
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

# Install CloudWatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb

# Create CloudWatch Agent config file
cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOF
${cloudwatch_config}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s



# Start Docker container for reverse proxy
docker pull nginx:alpine
docker rm -f namaste 2>/dev/null || true
# Create a custom index.html for the container
echo 'Namaste from G Container1' > /tmp/index.html
docker run -d --name namaste --restart always -p 8081:80 -v /tmp/index.html:/usr/share/nginx/html/index.html:ro nginx:alpine > /var/log/namaste_docker.log 2>&1

# NGINX config: one block for instance, one for Docker proxy
cat > /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name ec2-instance1.${domain_name};
    location / {
        default_type text/plain;
        return 200 'Hello from G Instance1';
    }
    location = /health {
        default_type text/plain;
        return 200 'OK';
    }
}

server {
    listen 80;
    server_name ec2-docker1.${domain_name};
    location / {
        proxy_pass http://localhost:8081;
        proxy_set_header Host "$host";
        proxy_set_header X-Real-IP "$remote_addr";
        proxy_set_header X-Forwarded-For "$proxy_add_x_forwarded_for";
        proxy_set_header X-Forwarded-Proto "$scheme";
    }
    location = /health {
        default_type text/plain;
        return 200 'OK';
    }
}
EOF

# Remove all old configs to avoid syntax errors
rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/conf.d/*
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Test and reload NGINX
nginx -t && systemctl reload nginx
