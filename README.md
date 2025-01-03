# Technical-test
Assignemnt


how to run IAC script

- First bring up the VPC with
aws cloudformation create-stack \
  --region us-east-1 \
  --stack-name my-eks-vpc \
  --template-body file://eks-vpc-stack.yaml 

  - use this command to bring up infra
  aws cloudformation create-stack \
  --region us-east-1 \
  --stack-name my-eks-cluster \
  --capabilities CAPABILITY_NAMED_IAM \
  --template-body file://eks-stack.yaml


  How to deploy helm charts:

##### Prerequisites:
#### EKS Cluster is already created and configured via CDK/CloudFormation.

#### kubectl is configured to interact with the EKS cluster (ensure that the kubeconfig is set up correctly).

## First, make sure that kubectl is installed on your machine. You can verify this by running:
- kubectl version --client
## Verify Installation of AWS CLI
- aws --version
## Configure AWS CLI with your AWS credentials (if not done already):
- aws configure
## Setup kubeconfig for WKS cluster
- aws eks update-kubeconfig --region us-east-2 --name my-eks-cluster
## If the connection to EKS is properly established the the below command will be showing the nodes in the EKS Cluster
- kubectl get nodes
## Check AWS CLI authentication: Ensure your AWS CLI is authenticated properly by running:
- aws sts get-caller-identity


## Install Helm on Machine If not, follow the [Helm Installation Guide.](https://helm.sh/docs/intro/install/)
