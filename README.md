# Flask Fargate App Deployment

# To run this app in your AWS account. follow the below steps.
  - Clone this repo to your local machine
  - Downlaod terraform (2 min youtube guide): [https://www.youtube.com/watch?v=9irfjbEzDz4]
  - Download aws cli and configure aws in your machine.
  - In github secret keys add ```AWS_ACCOUNT_ID```, ```AWS_ACCESS_KEY_ID``` and ```AWS_SECRET_ACCESS_KEY``` (*Node*:Make sure user has proper permission in AWs IAM)
  - In the cloned repo change the directory to infra2/ and run ```terraform init```, ```terraform plan```, and ```terraform apply```.
  - Run the github workflow from github Actions.


## Overview
This repository contains a tiny Flask app deployed on AWS ECS Fargate with HTTP/HTTPS, auto-scaling, and CI/CD pipeline.

**Features:**
- Single-container Flask app using SQLite.
- Deployed on ECS Fargate behind an ALB with Auto Scaling
- HTTP without ACM SSL certificate with loadbalancer dns.
- HTTPS with ACM SSL certificate for xyz.com. Note xyz.com require to be purchased.
- Auto-scaling based on CPU & memory usage.
- Logs & monitoring with CloudWatch.
- CI/CD pipeline via GitHub Actions.

## Architecture
```bash
flowchart TD
  subgraph VPC["VPC (10.0.0.0/16)"]
    IGW["Internet Gateway"]
    RT["Public Route Table"]

    SUB1["Public Subnet A (10.0.1.0/24) - us-east-1a"]
    SUB2["Public Subnet B (10.0.2.0/24) - us-east-1b"]

    ALB["Application Load Balancer"]
    TG["Target Group (port 5000)"]

    ECS["ECS Cluster (Fargate)"]
    TASKS["ECS Tasks (Flask Containers)"]

    ECR["ECR Repository (Docker Images)"]
    CW["CloudWatch Logs"]
  end

  User["User"] -->|HTTP (80) / HTTPS (443)| ALB
  ALB --> TG
  TG --> TASKS
  TASKS --> CW
  TASKS --> ECR
  SUB1 --> ALB
  SUB2 --> ALB
  IGW --> RT
  RT --> SUB1
  RT --> SUB2

# Deployment Flow

## Build & Push Docker Image to ECR

1. Build the Docker image:
   ```bash
   docker build -t flask-repo .
   docker tag flask-repo:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/flask-repo:latest
   docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/flask-repo:latest

## Apply Terraform to Provision Resources
    ```bash
    terraform init
    terraform plan
    terraform apply

## Access the App
    ```bash
    Via ALB DNS name: http://flask-alb-xxxxx.us-east-1.elb.amazonaws.com/login

    Or your custom domain (if Route53 + ACM are configured):


    https://domain.com/login
```

