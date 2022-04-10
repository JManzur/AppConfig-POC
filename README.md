
# Title

## Resources deployed by this manifest:

- AppConfig Module:
    - Application
    - Configuration Profile
    - Validator
    - Environment
    - Hosted Configuration
    - Deployment Strategy
    - Apply AppConfig Deployment
- VPU Module:
    - VPC
    - 1 Public Subnet
    - 1 Private Subnet
    - 1 Internet Gateway
    - 1 EIP for the NAT Gateway
    - NAT Gateway
    - Public Route Table
    - Private Route Table
    - Public Subnets Association
    - Private Subnets Association
- Lambda Module:
    - Python Lambda Function
    - IAM Role
    - API Gateway 
- EC2 Module:
    - Public Linux Instance running a Python API.
    - IAM Role to allow instance to get AppConfig Configuration.
    - Security group with whitelisted User IP (obtained automatically)
- ECS Module:
    - ECR
    - ECS Cluster
    - ECS Task (Python API)
    - IAM Role to allow container to get AppConfig Configuration.
    - ALB
    - Security Groups
    - CloudWatch Log Group
    - CloudWatch Log Stream



### Deployment diagram:

![App Screenshot](images/placeholder.png)

## Tested with: 

| Environment | Application | Version  |
| ----------------- |-----------|---------|
| WSL2 Ubuntu 20.04 | Terraform | v1.1.8  |
| WSL2 Ubuntu 20.04 | AWS-CLI | v2.5.3 |

## Initialization How-To:
Located in the root directory, make an "aws configure" to log into the aws account, and a "terraform init" to download the necessary modules and start the backend.

```bash
aws configure
terraform init
```

## Deployment How-To:

Located in the root directory, make the necessary changes in the variables.tf file and run the manifests:

```bash
terraform apply
```
## Deployment How-To:

## Debugging / Troubleshooting:

#### **Debugging Tip #1**: 

#### **Known issue #1**: 
 - **Issue**: 
    - You get one of the following errors when trying to push the image to ECR from a WSL2 + Docker Desktop installation.
        - ```Error saving credentials: error storing credentials - err: exit status255, out: ```
        - ```no basic auth credentials ```
- **Cause**: 
    - Bug in in a Docker Desktop update.
- **Solution**:
    - In the ~/.docker/config.json file, change **credsStore** to **credStore**.
    - Change the **credStore** value to **"desktop.exe"**

**Note**: You may also need to take the following actions:

```bash
docker logout
mv ~/.docker/config.json ~/.docker/config-OLD.json
```

## Author:

- [@JManzur](https://jmanzur.com)

## Documentation:

- [EXAMPLE](URL)