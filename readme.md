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

## 📅 Build Progress

### Day 1 — VPC & Networking
- Created VPC with CIDR `10.0.0.0/16`
- 2 public subnets + 2 private subnets across 2 availability zones
- Internet Gateway attached to public subnets
- Route tables configured per subnet
- Security groups with least privilege access

### Day 2 — Compute & Access Control
- Bastion Host deployed in public subnet (SSH locked to single IP)
- Private EC2 instance deployed with no public IP
- SSH jump configured: `laptop → Bastion → Private EC2`
- Verified private subnet has zero inbound internet access
- Security group on private EC2 allows SSH from Bastion SG only

---

## 🔒 Security Highlights
- App servers never directly exposed to internet
- SSH access restricted to single IP via security groups
- Private subnets isolated from inbound internet traffic
- Principle of least privilege applied to all security groups

---

## 🚧 Coming Soon
- [ ] Application Load Balancer
- [ ] Auto Scaling Group
- [ ] Docker + ECR
- [ ] Node.js REST API
- [ ] RDS PostgreSQL
- [ ] ElastiCache Redis
- [ ] Terraform (full IaC)
- [ ] GitHub Actions CI/CD
- [ ] CloudWatch monitoring