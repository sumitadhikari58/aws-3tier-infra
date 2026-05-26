# 🚀 AWS 3-Tier Infrastructure Project

## ✨ What I built
- 🌐 **VPC** with CIDR `10.0.0.0/16`
- 🔀 **2 public subnets, 2 private subnets** across 2 AZs
- 🔗 **Internet Gateway** attached
- 🛡️ **Bastion Host** on public subnet (Ubuntu 24.04, t2.micro)
- 🔐 Security group locked to my IP only on port 22

## 🏗️ Architecture
```
┌─────────────────────────────────────────┐
│          Public Subnet (AZ1)            │
│  ┌─────────────────────────────────┐    │
│  │    🛡️ Bastion Host              │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
           ↓ SSH Access ↓
┌─────────────────────────────────────────┐
│         Private Subnet (AZ1)            │
│  ┌─────────────────────────────────┐    │
│  │    📱 App Servers               │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
           ↓ Network ↓
┌─────────────────────────────────────────┐
│         Private Subnet (AZ2)            │
│  ┌─────────────────────────────────┐    │
│  │    🗄️ Database & Cache          │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

## 🛠️ Tech Stack
| Component | Technology |
|-----------|-----------|
| **Cloud** | AWS (VPC, EC2, ALB, RDS, ElastiCache, ECR) |
| **IaC** | Terraform (coming soon) ⏳ |
| **Containerization** | Docker 🐳 |
| **Backend** | Node.js + Express |
| **Database** | PostgreSQL + Redis |
| **CI/CD** | GitHub Actions 🔄 |