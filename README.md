# Final DevOps Project

## Overview of the project
## 1.1. I have been given a Node.js application that accepts a user input and displays the country data.
Command to install the dependencies:
```bash
npm install
```
Command to start the application:

```bash
npm start
```
![Screenshot (225)](https://github.com/user-attachments/assets/9e187c43-8bf0-49ae-89f9-ec80bf94ea40)

 Viewed the application running on localhost:3000.

![Screenshot (227)](https://github.com/user-attachments/assets/e8661913-484f-422e-b3ca-d73bb3504d16)


## Containerize the Application with Docker
## 2.1. Write the Dockerfile
Created a Dockerfile in the root of the project. 

## 2.2. Build the Docker Image
Built my Docker image.

```bash
docker build -t ojayde35/globalcurrency-countrydata-app:latest .
```
![Screenshot (242)](https://github.com/user-attachments/assets/6a3473b7-2b89-429a-a88e-95ca65199b96)

## 2.3. Run the Container Locally (Optional but Recommended)
Before pushing i did run the container locally to confirm it's working perfectly:

```bash
docker run -d -p 3000:3000 ojayde35/globalcurrency-countrydata-app:latest
```
![Screenshot (243)jr](https://github.com/user-attachments/assets/01a273a8-2378-4c79-91a1-ed2be148794c)

viewed the application running on localhost:3000 in your browser.

![Screenshot (241)](https://github.com/user-attachments/assets/2d27a537-a133-4bef-8832-c904d7fccfb2)

## 2.4. Push the Image to Your Docker Hub Registry
logged in to Docker Hub from your terminal:

```bash
docker login -u
```
Once logged in, i pushed the image:
```bash
docker push ojayde35/globalcurrency-countrydata-app:latest
```
![Screenshot (266)](https://github.com/user-attachments/assets/598c04c2-c8e4-4754-8360-a2f5cc694865)

## Deploy the Application to Amazon Elastic Kubernetes Service (EKS) using Terraform
This section outlines the steps for provisioning your EKS cluster using Terraform.

## 3.1. Terraform Configuration Files
I created Terraform configuration files (main.tf, variables.tf, outputs.tf, versions.tf) to define your EKS cluster, VPC, subnets, security groups, and IAM roles.
Run the provided setup script to install Terraform, kubectl, and AWS CLI:
```bash

chmod +x script.sh
./script.sh
```
![Screenshot (246)](https://github.com/user-attachments/assets/25c5ded3-1787-4bbf-badf-d1f38b43db3d)

```bash
aws configure
```
![Screenshot (247)](https://github.com/user-attachments/assets/eaa7c3fe-af7c-4cf8-8f08-94160a2d6a87)

## 3.2. Initialize Terraform
Navigated to my Terraform configuration directory and initialized Terraform:

```bash
cd EKS-TF
terraform init
```
![Screenshot (255)init](https://github.com/user-attachments/assets/d118a183-b041-4a87-9c7e-666722f5461b)

## 3.3. Plan the Infrastructure
Review the execution plan to see what Terraform will create:
```bash
terraform plan
```
## 3.4. Apply the Infrastructure
![Screenshot (255)plan](https://github.com/user-attachments/assets/928cc949-330c-486d-9f5f-2b21edc3fa43)

Provision the EKS cluster and associated resources:
```bash
terraform apply
```
![Screenshot (256)apply](https://github.com/user-attachments/assets/03d4f437-489a-4b20-9bd6-7f524e1cfb8b)

![Screenshot (257)](https://github.com/user-attachments/assets/030da969-e27d-4989-bcee-426a45737c43)

![Screenshot (258)](https://github.com/user-attachments/assets/82505720-b4aa-48bd-bc9d-b1a5f5c87be5)

![Screenshot (263)](https://github.com/user-attachments/assets/625e5513-c4b5-412b-8fbc-c0a221a4d4fe)

## 3.5 Configure kubectl

Updated kubeconfig to connect to the new EKS cluster:

```bash
aws eks update-kubeconfig --region eu-west-1 --name globalcurrency-countrydata-cluster
```

## 3.6 Apply your Kubernetes deployment and service manifests.

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
Waited for the deployment to be ready and the AWS Load Balancer to be provisioned.
```bash
kubectl rollout status deployment/globalcurrency-countrydata-deployment
```
Got the LoadBalancer URL to access your application:

```bash
kubectl get service globalcurrency-countrydata-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
The output will be the public DNS name of your AWS Load Balancer.


## 4 Automate Deployment 
This section details the CI/CD pipeline to deploy my application to EKS.

## 4.1. Configure GitHub Repository Secrets
I added the following secrets to my GitHub repository (Settings > Secrets and variables > Actions > New repository secret):

AWS_ACCESS_KEY_ID: AWS Access Key ID (for aws-actions/configure-aws-credentials).

AWS_SECRET_ACCESS_KEY: AWS Secret Access Key (for aws-actions/configure-aws-credentials).

ECR_REPOSITORY: The value is the name of the Amazon ECR repository created in AWS.

![Screenshot (279)](https://github.com/user-attachments/assets/5504fa64-65a0-4b49-8392-e45cb9e34d1a)

## 4.2. GitHub Actions Workflow (.github/workflows/main.yml)
Created a file named pipeline.yml inside the .github/workflows/ directory in the repository. This workflow will:

Checkout code: Retrieve the latest version of your application code from the GitHub repository.

Configure AWS credentials: Set up the necessary AWS authentication on the runner to interact with AWS services.

Login to Amazon ECR: Authenticate the Docker client with your ECR registry, allowing it to push and pull images.

![Screenshot (273)](https://github.com/user-attachments/assets/2f5fc914-3165-4274-a19a-1c4ebe53b754)

Build and push Docker image to ECR: Compile your application into a Docker image and upload it to your ECR repository.

![Screenshot (267)](https://github.com/user-attachments/assets/abcdcfce-2099-4b01-b4e9-28558b17653c)

![Screenshot (277)](https://github.com/user-attachments/assets/3512a65e-4854-400d-9341-58cf276bf7f2)

Update Kubeconfig for EKS: Configure kubectl on the runner to connect to your active Amazon EKS cluster.

Deploy to EKS: Apply your Kubernetes deployment and service manifests to the EKS cluster, update the application image, and ensure the application is running and accessible via an AWS Load Balancer.
NOTE: In my deployment yaml file, my image is ecr repository image

![Screenshot (280)ecr](https://github.com/user-attachments/assets/3115d199-0bd4-4f93-b2fe-820fcff94674)

## 4.3 Access the Deployed Application

Once the GitHub Actions workflow completes successfully, your application will be deployed to the AWS EKS cluster and exposed via an AWS Load Balancer. You can access your application directly using the Load Balancer's public DNS name.

![Screenshot (275)](https://github.com/user-attachments/assets/c1b81b04-c98a-46f5-b798-c04ce20abd3b)

## 4.4 Get the Load Balancer URL

The GitHub Actions workflow's "Deploy to EKS" step will output the Load Balancer URL. You can find this in the workflow logs. Alternatively, you can retrieve it directly from your terminal after the deployment:

```bash
kubectl get service globalcurrency-countrydata-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```
![Screenshot (274)](https://github.com/user-attachments/assets/b309ddbb-cf9f-49e7-8edc-b1fc768ce062)

*** Clean up
## terraform destroy
cd EKS-TF
terraform destroy
```
To avoid unccessary charges.
