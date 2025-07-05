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
Navigate to your Terraform configuration directory and initialize Terraform:

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
Waited for the deployment to be ready.
```bash
kubectl get service globalcurrency-countrydata-service
```
 The Minikube service URL was available.

![Screenshot (270)](https://github.com/user-attachments/assets/d9e88520-c5e9-4af4-8b8e-b79f74da262f)

![Screenshot (271)](https://github.com/user-attachments/assets/6076bfae-517f-41fc-ab8a-6a1f170671d5)

## 4 Automate Deployment 
using GitHub Actions (Minikube on EC2)
This section details the CI/CD pipeline to deploy my application to a Minikube cluster running on an EC2 instance.

## 4.1. Configure GitHub Repository Secrets
I added the following secrets to my GitHub repository (Settings > Secrets and variables > Actions > New repository secret):

EC2_SSH_KEY: The entire content of EC2 instance's SSH private key.

SERVER_USERNAME: The SSH username for  EC2 instance (e.g., ubuntu).

SERVER_HOST: The Public IP address or Public DNS name of EC2 instance.

AWS_ACCESS_KEY_ID: Your AWS Access Key ID (for aws-actions/configure-aws-credentials).

AWS_SECRET_ACCESS_KEY: Your AWS Secret Access Key (for aws-actions/configure-aws-credentials).

(Optional) DOCKERHUB_USERNAME: Docker Hub username (if uncommenting Docker login).

(Optional) DOCKERHUB_TOKEN:  Docker Hub Personal Access Token (PAT) (if uncommenting Docker login).

![Screenshot (267)](https://github.com/user-attachments/assets/e52e8f44-6d0d-4114-8685-c22271bc5214)

## 4.2. GitHub Actions Workflow (.github/workflows/main.yml)
Created a file named pipeline.yml inside the .github/workflows/ directory in the repository. This workflow will:

Connect to EC2 instance via SSH.

Clean and create the application directory on EC2.

Securely copy your project files to the EC2 instance.

Inside the EC2 instance's shell:

Start Minikube.

Build the Docker image locally.

Load the image into Minikube.

## 4.5 Access the Deployed Application
My application is now deployed to a Minikube cluster running on EC2 instance. The minikube service --url command provided an internal IP. To access this from the local machine's browser, i had to create an SSH tunnel.

## 4.6 Get EC2 Instance Public IP/DNS
Obtained the Public IPv4 address or Public IPv4 DNS of your EC2 instance from the AWS EC2 Console.

## 4.7 Create SSH Tunnel from Your Local Machine
I opened a new terminal window on your local computer (not on the EC2 instance). I used the following SSH command, replacing placeholders with your actual values:

```bash
chmod 400 "<YOUR_RIVATE_KEY_PEM.pem>"
```
```bash
ssh -i "<YOUR_RIVATE_KEY_PEM.pem>" ubuntu@ec2-54-229-187-189.eu-west-1.compute.amazonaws.com
```
![Screenshot (264)](https://github.com/user-attachments/assets/7c11c11a-0049-434e-b25d-737e6e680b77)

## 4.8 Access in Browser
Confirmed on the web browser on my local machine and navigated to:

http://localhost:3000

![Screenshot (265)](https://github.com/user-attachments/assets/8aeee62d-2e9c-471d-87b5-d71e512d6176)

*** Clean up
## terraform destroy
cd EKS-TF
terraform destroy
```
![Screenshot (272)](https://github.com/user-attachments/assets/a1cd0bd5-0f9d-4d17-b93c-078e939ade7b)
