# SAMPLEAPP_LINUX

A fully containerized web application with an automated CI/CD pipeline on AWS.  This project demonstrates best practices for deploying and managing web applications on Linux infrastructure using AWS CodePipeline, CodeBuild, and CodeDeploy.

---

[![License](https://img.shields.io/badge/license-Apache%202.0-blue)](#license)
[![Language](https://img.shields.io/badge/language-HTML%20%7C%20Shell-orange)](#)
[![Repository](https://img.shields.io/badge/repo-lahda%2FSAMPLEAPP__LINUX-brightgreen)](#)
[![Last Updated](https://img.shields.io/badge/updated-2025--12--30-informational)](#)

## Table of Contents

- [About](#about)
- [Architecture](#architecture)
- [Key Features](#key-features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Clone & Setup](#clone--setup)
  - [Local Testing](#local-testing)
- [AWS Deployment](#aws-deployment)
- [Build & Deploy Pipeline](#build--deploy-pipeline)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## About

**SAMPLEAPP_LINUX** is a sample web application designed to showcase a complete CI/CD workflow on Amazon Web Services (AWS). It combines a simple HTML-based web frontend with automated deployment scripts, demonstrating how to build, test, and deploy applications reliably across AWS infrastructure.

This project is ideal for: 
- Learning AWS CI/CD best practices
- Understanding CodePipeline, CodeBuild, and CodeDeploy workflows
- Deploying web applications on EC2 instances with automated updates
- Implementing infrastructure-as-code principles for application delivery

## Architecture

The following diagram illustrates the complete AWS CI/CD pipeline architecture, showing how code flows from source control through build and deployment stages: 

![AWS Full CI/CD Pipeline Architecture](https://github.com/lahda/SAMPLEAPP_LINUX/raw/main/AWS%20Full%20CICD%20Pipeline%20Architecture.drawio.png)

### Architecture Overview

1. **Source Stage**: Changes pushed to the GitHub repository trigger the pipeline
2. **Build Stage**: AWS CodeBuild compiles and packages the application
3. **Deploy Stage**: AWS CodeDeploy distributes the application to EC2 instances
4. **Runtime**:  The application runs on Linux EC2 instances with automatic lifecycle management

## Key Features

- ✅ **Automated CI/CD Pipeline** – Continuous integration and deployment via AWS CodePipeline
- ✅ **Infrastructure as Code** – Declarative build and deployment specifications
- ✅ **Multi-Stage Deployment** – Separate build and deployment configurations
- ✅ **Scalable Architecture** – Designed for elastic deployment across multiple instances
- ✅ **Application Lifecycle Management** – Graceful deployment with hooks (Start, Stop, Install)
- ✅ **Shell Scripting Automation** – Custom deployment scripts for application setup
- ✅ **Apache License 2.0** – Open-source and freely usable

## Tech Stack

| Component | Technology |
|-----------|------------|
| **Frontend** | HTML5 |
| **Infrastructure** | AWS (EC2, CodePipeline, CodeBuild, CodeDeploy) |
| **Build Tool** | AWS CodeBuild |
| **Deployment Tool** | AWS CodeDeploy |
| **Scripting** | Bash/Shell |
| **Version Control** | Git / GitHub |
| **OS** | Linux (Amazon Linux 2 / Ubuntu) |

## Project Structure

```
SAMPLEAPP_LINUX/
├── index.html                                    # Main HTML application file
├── buildspec.yml                                 # AWS CodeBuild specification
├── appspec.yml                                   # AWS CodeDeploy specification
├── scripts/                                      # Deployment and lifecycle scripts
│   ├── install_dependencies.sh                   # Install required packages
│   ├── start_application.sh                      # Start the application
│   ├── stop_application.sh                       # Stop the application
│   
├── AWS Full CICD Pipeline Architecture.drawio.png # Architecture diagram
├── LICENSE. txt                                   # Apache License 2.0
└── README.md                                     # This file
```

## Getting Started

### Prerequisites

- **Git** 2.x or higher
- **AWS Account** with appropriate IAM permissions
- **EC2 Instance** running Amazon Linux 2 or Ubuntu 20.04+
- **AWS CLI** v2 (for local AWS interactions)
- **CodeDeploy Agent** installed on EC2 instances

### Clone & Setup

1. Clone the repository: 

```bash
git clone https://github.com/lahda/SAMPLEAPP_LINUX.git
cd SAMPLEAPP_LINUX
```

2. Verify the structure:

```bash
ls -la
```

You should see `index.html`, `buildspec.yml`, `appspec.yml`, and `scripts/` directory.

### Local Testing

To test the application locally on a Linux machine:

1. Install a web server (Apache or Nginx):

```bash
# For Amazon Linux 2
sudo yum update -y
sudo yum install -y httpd

# For Ubuntu
sudo apt-get update
sudo apt-get install -y apache2
```

2. Copy the application to the web root:

```bash
sudo cp index.html /var/www/html/
```

3. Start the web server:

```bash
# Amazon Linux 2
sudo systemctl start httpd
sudo systemctl enable httpd

# Ubuntu
sudo systemctl start apache2
sudo systemctl enable apache2
```

4. Access the application:

```
http://localhost
```

## AWS Deployment

### Prerequisites on AWS

1. **Create an EC2 Instance**:
   - OS: Amazon Linux 2 or Ubuntu 20.04+
   - IAM Role: Assign a role with CodeDeploy permissions
   - Security Group: Allow inbound HTTP (port 80) and HTTPS (port 443)

2. **Install CodeDeploy Agent**: 

```bash
# Amazon Linux 2
sudo yum update -y
sudo yum install -y ruby wget

cd /home/ec2-user
wget https://aws-codedeploy-${REGION}.s3.${REGION}.amazonaws.com/latest/install

chmod +x ./install
sudo ./install auto

sudo systemctl start codedeploy-agent
sudo systemctl enable codedeploy-agent
```

3. **Configure IAM Role**:  Ensure the EC2 instance role includes: 
   - `AmazonEC2RoleforAWSCodeDeploy`
   - `AmazonSSMManagedInstanceCore`

### Set Up the CI/CD Pipeline

1. **Create GitHub Connection** in AWS Console
2. **Create CodePipeline**:
   - Source: GitHub repository
   - Build: Configure with `buildspec.yml`
   - Deploy: Configure with `appspec.yml`
3. **Trigger**:  Push changes to the repository to start the pipeline

## Build & Deploy Pipeline

### BuildSpec (buildspec.yml)

The `buildspec.yml` defines the build process: 

```yaml
version: 0.2

phases:
  install:
    runtime-versions: 
      # Defines runtime versions for the build environment
  build:
    commands:
      # Build and validation commands
      - echo "Building the application..."
  post_build:
    commands: 
      - echo "Build completed successfully"

artifacts:
  files:
    - '**/*'  # Package all files
```

### AppSpec (appspec. yml)

The `appspec.yml` defines the deployment process:

```yaml
version: 0.0
os: linux

files:
  - source: /
    destination: /var/www/html

hooks:
  ApplicationStart:
    - location: scripts/start_application.sh
  ApplicationStop:
    - location:  scripts/stop_application.sh
```

### Deployment Lifecycle

1. **BeforeBlockTraffic** – Pre-deployment checks
2. **BlockTraffic** – Route traffic away (for rolling deployments)
3. **ApplicationStop** – Gracefully stop the current application
4. **BeforeInstall** – Prepare the deployment environment
5. **Install** – Copy files and install dependencies
6. **ApplicationStart** – Start the application
7. **ValidateService** – Run health checks
8. **UnblockTraffic** – Resume routing traffic

## Configuration

### Environment Variables

Create a `.env` file or configure in your EC2 instance (optional):

```bash
# Application configuration
APP_PORT=80
APP_NAME=SampleApp
LOG_LEVEL=INFO
```

### Log Files

- **CodeBuild Logs**: AWS CloudWatch (search for CodeBuild project name)
- **CodeDeploy Logs**: `/var/log/codedeploy-agent/codedeploy-agent.log`
- **Application Logs**:  Configured in your deployment scripts

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create a feature branch**:  `git checkout -b feature/my-feature`
3. **Commit your changes**: `git commit -m "Add my feature"`
4. **Push to your branch**: `git push origin feature/my-feature`
5. **Open a Pull Request** with a clear description

### Development Guidelines

- Follow shell script best practices (use `set -e` for error handling)
- Test deployment scripts locally before pushing
- Update documentation for infrastructure changes
- Ensure all scripts are executable:  `chmod +x scripts/*. sh`

## License

This project is licensed under the **Apache License 2.0** — see the [LICENSE.txt](LICENSE.txt) file for details.

## Contact

**Author**: lahda  
**GitHub**: [@lahda](https://github.com/lahda)  
**Repository**: [lahda/SAMPLEAPP_LINUX](https://github.com/lahda/SAMPLEAPP_LINUX)

For questions, issues, or suggestions, please open an [issue](https://github.com/lahda/SAMPLEAPP_LINUX/issues) on GitHub.

---

## FAQ

**Q: How do I trigger the CI/CD pipeline?**  
A: Simply push changes to the main branch.  The GitHub connection in your CodePipeline will automatically detect the push and start the pipeline.

**Q: What regions are supported?**  
A:  This deployment works in any AWS region where EC2, CodePipeline, CodeBuild, and CodeDeploy are available.

**Q: How do I debug deployment failures?**  
A: Check CloudWatch logs in the AWS Console under CodePipeline and CodeDeploy stages. Detailed logs will show exactly where the deployment failed.

**Q: Can I use this with other platforms besides AWS?**  
A: The HTML and scripts are portable, but you'll need to adapt the pipeline configuration for other CI/CD tools (Jenkins, GitLab CI, etc.).

**Q: How do I scale to multiple instances?**  
A:  Configure an Auto Scaling Group and attach it to your CodeDeploy deployment.  Deployments will automatically roll out to all instances.

---

**Last Updated**: 2025-12-30  
**Status**: Production-Ready
