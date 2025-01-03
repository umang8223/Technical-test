# Technical-test

This repository shows how to how to provision an Amazon EKS cluster, set up a CI/CD pipeline(GitHub Actions) to create and publish a Docker image to Amazon ECR, and use Helm to deploy an NGINX container.

---

## Table of Contents
- [How to Run IAC Scripts](#how-to-run-iac-scripts)
- [How to Deploy Helm Charts](#how-to-deploy-helm-charts)
- [CI/CD Pipeline](#cicd-pipeline)

---

## How to Run IAC Scripts
The first step in the project is to setting up the infrastructure for the application with the help of CloudFormation, The below resouces will be created on the execution of CloudFormation script.

- **VPC**
- **EKS Cluster**
- **S3 Bucket**

## Prerequisites
- AWS CLI is installed and configured with the appropriate credentials.
- You have access to the CloudFormation template file.
- The repository contains the CloudFormation template under the `Technical-test/Infrastructure` directory.

### 1. Navigate to the CloudFormation Template Directory

Open your terminal and navigate to the `Technical-test/Infrastructure` directory where the CloudFormation template is located:

```bash
cd path-to-your-repo/Technical-test/Infrastructure
```

### 2. Provision the VPC
Before creating the EKS cluster, the first step is to bring up the required VPC.

```bash
aws cloudformation create-stack \
  --region us-east-1 \
  --stack-name my-eks-vpc \
  --template-body file://eks-vpc-stack.yaml
```

### 2. Provision the EKS-Cluster
Now we can create the Cluster with the help of Below command and it will setup the cluster with the necessary configuration and IAM roles.
```bash
aws cloudformation create-stack \
  --region us-east-1 \
  --stack-name my-eks-cluster \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://eks-stack.yaml
```

#### Here is the screenshot of [EKS](images/Cluster-node.png) [S3](images/s3.png)

---

## How to deploy Helm charts

In this task we will create helm chart to deploy it on NGIX Conatiner on EKS Cluster formed in the above task. This deployment is configured to expose the NGINX service with the help of K8s LoadBalancer, it will be accessible from external traffic. This task Involves

1. Creating a Helm chart for NGINX Deployment.
2. Installing Helm Chart on K8s Cluster.
3. Exposing the service via a LoadBalancer - This make sures that NGINX Container is accessed from the internet.

### Prerequisites:
EKS Cluster is already created and configured via CDK/CloudFormation.
kubectl is configured to interact with the EKS cluster (ensure that the kubeconfig is set up correctly).

### First, make sure that kubectl is installed on your machine. You can verify this by running:
```bash
- kubectl version --client

### Verify Installation of AWS CLI
- aws --version

### Configure AWS CLI with your AWS credentials (if not done already):
- aws configure

### Setup kubeconfig for EKS cluster
- aws eks update-kubeconfig --region us-east-1 --name my-eks-cluster

### If the connection to EKS is properly established the the below command will be showing the nodes in the EKS Cluster
- kubectl get nodes

### Check AWS CLI authentication: Ensure your AWS CLI is authenticated properly by running:
- aws sts get-caller-identity
```

### Install Helm on Machine If not, follow the [Helm Installation Guide.](https://helm.sh/docs/intro/install/)

### Create a Helm Chart for NGINX Deployment

```bash
#### Initialize helm

First you need to run the below command to generate a basic helm chart
helm create nginx-deployment

This will create a new directory named nginx-deployment

#### Install the Helm Chart on the EKS Cluster:
helm install nginx-release ./nginx-deployment

#### Verify the Deployment:
kubectl get pods

#### Check the LoadBalancer URL:
kubectl get svc nginx-release-nginx-deployment

#### The output will **look** like this:
NAME                             TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)        AGE
nginx-release-nginx-deployment   LoadBalancer   10.100.48.144   a47776a-1960.us-east-1.elb.amazonaws.com   80:30267/TCP   31m
```

#### Access NGINX via LoadBalancer:
Open a web browser and navigate to the EXTERNAL-IP from the previous step. You should see the default NGINX welcome page.

#### Here is the screenshot of [NGINX Deployment](images/nginx.png)

---

## CI/CD Pipeline

This section shows the simple setup of an CI/CD pipeline using **GitHub Actions** to Automate the process of building and Deploying the image to **Amazon ECR**. The pipeline has 2 steps.

1. **Build Docker Image**
2. **Push the Docker image to AmazonECR**

### Prerequisites:
1. Amazon ECR Repository
2. AWS CLI
3. GitHub Secrets
4. AWS Secrets: Store AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ACCOUNT_ID, and ECR_REPOSITORY_NAME

### Summary of Workflow steps
CI/CD Pipeline triggers when changes are pushed on the main branch.

1. Checkout Code: this step retries the lates code form the repo.
2. Setup AWS CLI: It configures the AWS CLI with the help of AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, and Region
3. Login to ECR: Authenticates Docker CLI to connect withe the ECR by using the AWS credentials.
4. Build Docker image: It builts the Image based on the Dockerfile located in the repository.
5. Tag Image: The above built image is tagged with appropriate ECR Repo URL.
6. Push to Amazon ECR: Pushes the above tagged to image to ECR Registry.

#### Here is the screenshot of succesful [GitHub Actions](GitHub-actions.png)
