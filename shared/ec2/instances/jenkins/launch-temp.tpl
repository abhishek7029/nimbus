#!/bin/bash

sudo yum update -y
sudo yum upgrade -y

sudo yum install java-17-amazon-corretto -y
sudo yum install unzip -y
sudo yum install zip -y

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
jenkins --version



sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx
nginx -t
nginx -version

sudo yum install git -y
git --version

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo tee /etc/nginx/conf.d/server.conf << 'EOF'
server {
listen 80;
location /nginx-health {
add_header Content-Type application/json;
return 200 '{"status":"healthy"}';
}
location / {
proxy_pass "http://127.0.0.1:8080";
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-Server $host;
proxy_set_header Host $http_host;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; }
}
EOF
systemctl restart nginx
systemctl enable nginx
systemctl status nginx