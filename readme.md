# AWS 3-Tier Infrastructure — URL Shortener

> A production-grade cloud infrastructure built from scratch on AWS.
> Designed for scalability, security, and zero-downtime deployments.

---

## 🎯 Project Goals
- Simulate a real-world production deployment on AWS
- Apply industry-standard security practices (private subnets, least privilege)
- Automate everything — infrastructure as code, CI/CD, monitoring
- Build something interviewers actually want to see

---

## ⚡ Key Features
- **Highly Available** — Multi-AZ deployment, no single point of failure
- **Auto Scaling** — Scales out under load, scales in when idle
- **Zero Direct Exposure** — App servers have no public IP, only ALB is internet-facing
- **Infrastructure as Code** — Entire AWS setup reproducible with one Terraform command
- **Automated Deploys** — Push to main → Docker build → ECR push → live in minutes
- **Caching Layer** — Redis sits in front of DB, repeated lookups never hit PostgreSQL
- **Secure by Design** — Every security group follows least privilege principle

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Cloud | AWS (VPC, EC2, ALB, RDS, ElastiCache, ECR) |
| IaC | Terraform |
| Containerisation | Docker |
| Backend | Node.js + Express |
| Database | PostgreSQL + Redis |
| CI/CD | GitHub Actions |
| Monitoring | CloudWatch + Grafana |

---

## 🏗️ Architecture
Internet
│
▼
Application Load Balancer (public subnet)
│
▼
Auto Scaling Group — EC2 + Docker (private subnet)
│
├──▶ RDS PostgreSQL (private subnet)
└──▶ ElastiCache Redis (private subnet)
Developer Access:
Laptop → Bastion Host (public) → Private EC2
---

## 🔒 Security Design
- App servers in private subnet — no public IP, no direct internet access
- ALB is the only public-facing component
- SSH locked to developer IP only via security groups
- DB and cache accessible only from app tier security group
- NAT Gateway for outbound-only internet access from private subnet
- Principle of least privilege on every security group

---

## 📅 Build Progress

### Day 1 — VPC & Networking
- Created VPC with CIDR `10.0.0.0/16`
- 2 public subnets + 2 private subnets across 2 AZs (ap-south-1a, ap-south-1b)
- Internet Gateway attached to public subnets
- Route tables configured per subnet
- Security groups with least privilege access

### Day 2 — Compute & Access Control
- Bastion Host deployed in public subnet (SSH locked to single IP `/32`)
- Private EC2 launched with no public IP
- SSH jump working: `laptop → Bastion → Private EC2`
- Verified private subnet has zero inbound internet access

### Day 3 — Load Balancer & NAT Gateway
- Application Load Balancer created in public subnets across 2 AZs
- Target Group configured with `/health` health check
- NAT Gateway added — private EC2 can now make outbound requests
- Private route table updated with `0.0.0.0/0 → NAT Gateway`
- Node.js 20 installed on private EC2

### Day 4 — Application Layer
- Express app deployed on private EC2
- `/health` endpoint returning `{ status: "ok" }`
- Private EC2 registered in Target Group
- ALB routing verified end to end via curl

### Day 5 — Docker
- Dockerfile written with Alpine base
- Image built and container running on private EC2
- ALB routing verified through Docker container

### Day 6 — ECR
- AWS CLI installed and configured on private EC2
- Docker image tagged and pushed to ECR
- Image available at 108209429292.dkr.ecr.ap-south-1.amazonaws.com/url-shortener:latest

### Day 7 — Auto Scaling Group
- Launch Template created with User Data script
- ASG configured: min 1, max 3, desired 1
- CPU > 70% triggers scale out
- Fixed NAT Gateway route for private subnet ap-south-1b
- ASG auto-recovery verified — terminated instance replaced automatically

### Day 8 — ASG Fixed
- Debugged User Data script failures
- Fixed NAT Gateway route for ap-south-1b
- IAM Role attached for ECR authentication
- Fixed TTY pipe issue with docker login
- ASG now auto-launches instances with Docker container running
- ALB routing verified end to end

### Day 9 — Docker Compose
- Added docker-compose.yml with 3 services: app, PostgreSQL, Redis
- PostgreSQL and Redis containers running successfully
- App container debugging in progress (route handler fix)
- All services connected on same Docker network

### Day 10 — URL Shortener API Complete
- POST /shorten — generates short code, stores mapping
- GET /:code — redirects to original URL
- GET /health — ALB health check
- Full flow tested end to end via ALB DNS
---

## ✅ Completed
- [x] VPC + Networking
- [x] Bastion Host + Private EC2
- [x] Application Load Balancer
- [x] Target Group with health check
- [x] NAT Gateway
- [x] Express app on private EC2
- [x] ALB routing verified end to end
- [x] Docker
- [x] ECR — Docker image pushed
- [x] Auto Scaling Group
- [x] Launch Template with User Data
- [x] PostgreSQL (Docker container)
- [x] Redis (Docker container)
- [x] Full URL shortener API

## 🚧 In Progress
- [ ] Terraform (full IaC)
- [ ] GitHub Actions CI/CD
- [ ] CloudWatch monitoring