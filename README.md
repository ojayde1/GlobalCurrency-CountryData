# Final DevOps Project
Congratulations on progressing to this stage in your DevOps journey. Now is the time to show off the stuff you're made of. 

## Instructions to complete the task 

This is your final DevOps project. Over the past 4 months, we have delved into several key DevOps tools and practices. Now is the time to use all the knowledge you have gained to achieve this end-to-end devops task. 


## Overview of the project

You have been given a nodejs application that accpets a user input and displays the country data. 

Clone the repository, and test the application locally to be sure its working. 
Run this command to install the dependencies

```bash
npm install
```


and then run this command to start the application 
```bash
npm start
```

You can view the application running on loacalhost:3000 

## Your Task 

 - Write the Dockerfile to containerize the application. Build the docker image, push the image to your dockerhub registry
 - Run the container and confirm it working perfectly. 
 - Write the terraform configuration files to deploy the Application to Amazon Elastic Kubernetes Service
 - Automate the entire deployment using Github Actions 

 ## Deliverables 
  - Take screenshots of every step, and include it in your README.md.
  - When you're done with the project, destroy your entire infrastructure using the terraform destroy command.

  ## Goodluck and all the best! 


# Final DevOps Project

## Overview of the project
## 1.1. You have been given a Node.js application that accepts a user input and displays the country data.

Clone the repository, and test the application locally to be sure it's working.
Run this command to install the dependencies:

```bash
npm install
```
And then run this command to start the application:

```bash
npm start
```
You can view the application running on localhost:3000.

Screenshot: Local Application Running
(Include a screenshot of your application running successfully on localhost:3000)


## Containerize the Application with Docker
## 2.1. Write the Dockerfile
Create a Dockerfile in the root of your project. 


## 2.2. Build the Docker Image
Build your Docker image. Make sure you are in the root directory of your project where your Dockerfile is located.

```bash
docker build -t ojayde35/globalcurrency-countrydata-app:latest .
```


Screenshot: Docker Image Build Success
(Include a screenshot of the successful Docker image build output)

## 2.3. Run the Container Locally (Optional but Recommended)
Before pushing, run the container locally to confirm it's working perfectly:

```bash
docker run -d -p 3000:3000 ojayde35/globalcurrency-countrydata-app:latest
```

You can view the application running on localhost:3000 in your browser.

Screenshot: Local Docker Container Running
(Include a screenshot of your application running successfully in a Docker container on localhost:3000)

## 2.4. Push the Image to Your Docker Hub Registry
First, log in to Docker Hub from your terminal:

```bash
docker login -u
```
Follow the browser-based authentication prompt. Press ENTER when prompted to open your browser, complete the login there, and your terminal will then log in automatically.

Once logged in, push the image:

```bash
docker push ojayde35/globalcurrency-countrydata-app:latest
```
Screenshot: Docker Image Pushed to Docker Hub
(Include a screenshot of the successful docker push output)

## Deploy the Application to Amazon Elastic Kubernetes Service (EKS) using Terraform
This section outlines the steps for provisioning your EKS cluster using Terraform.

## 3.1. Terraform Configuration Files
Create your Terraform configuration files (main.tf, variables.tf, outputs.tf, versions.tf) to define your EKS cluster, VPC, subnets, security groups, and IAM roles.

Run the provided setup script to install Terraform, kubectl, and AWS CLI:

```bash
chmod +x script.sh
./script.sh
```

```bash
aws configure
```

## 3.2. Initialize Terraform
Navigate to your Terraform configuration directory and initialize Terraform:

```bash
cd EKS-TF
terraform init
```

## 3.3. Plan the Infrastructure
Review the execution plan to see what Terraform will create:
```bash
terraform plan
```
terraform plan

## 3.4. Apply the Infrastructure
Provision the EKS cluster and associated resources:

```bash
terraform apply
```

Screenshot: Terraform Apply Success
(Include a screenshot of the successful terraform apply output)

## Automate Deployment using GitHub Actions (Minikube on EC2)
This section details the CI/CD pipeline to deploy your application to a Minikube cluster running on an EC2 instance.

## 4.1. Configure GitHub Repository Secrets
You need to add the following secrets to your GitHub repository (Settings > Secrets and variables > Actions > New repository secret):

EC2_SSH_KEY: The entire content of your EC2 instance's SSH private key.

SERVER_USERNAME: The SSH username for your EC2 instance (e.g., ubuntu).

SERVER_HOST: The Public IP address or Public DNS name of your EC2 instance.

AWS_ACCESS_KEY_ID: Your AWS Access Key ID (for aws-actions/configure-aws-credentials).

AWS_SECRET_ACCESS_KEY: Your AWS Secret Access Key (for aws-actions/configure-aws-credentials).

(Optional) DOCKERHUB_USERNAME: Your Docker Hub username (if uncommenting Docker login).

(Optional) DOCKERHUB_TOKEN: A Docker Hub Personal Access Token (PAT) (if uncommenting Docker login).

Screenshot: GitHub Secrets Configuration
(Include a screenshot showing your configured GitHub secrets)

## 4.2. GitHub Actions Workflow (.github/workflows/main.yml)
Create a file named main.yml inside the .github/workflows/ directory in your repository. This workflow will:

Connect to your EC2 instance via SSH.

Clean and create the application directory on EC2.

Securely copy your project files to the EC2 instance.

Inside the EC2 instance's shell:

Start Minikube.

Build the Docker image locally.

Load the image into Minikube.

Apply your Kubernetes deployment and service manifests.

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
Wait for the deployment to be ready.

```bash
kubectl get service globalcurrency-countrydata-service
```
Get the Minikube service URL.

Screenshot: GitHub Actions Workflow Run Success
(Include a screenshot of a successful GitHub Actions workflow run, showing all steps green)

## 4.5 Access the Deployed Application
Your application is now deployed to a Minikube cluster running on your EC2 instance. The minikube service --url command provided an internal IP (http://192.168.49.2:31328). To access this from your local machine's browser, you need to create an SSH tunnel.

## 4.6 Get EC2 Instance Public IP/DNS
Obtain the Public IPv4 address or Public IPv4 DNS of your EC2 instance from the AWS EC2 Console.

## 4.7 Create SSH Tunnel from Your Local Machine
Open a new terminal window on your local computer (not on the EC2 instance). Run the following SSH command, replacing placeholders with your actual values:

```bash
chmod 400 "<YOUR_RIVATE_KEY_PEM.pem>"

```

```bash
ssh -i "<YOUR_RIVATE_KEY_PEM.pem>" ubuntu@ec2-54-229-187-189.eu-west-1.compute.amazonaws.com
```

## 4.8 Access in Browser
Open your web browser on your local machine and navigate to:

http://localhost:3000

You should see your globalcurrency-countrydata-app running!

Screenshot: Application Accessible via SSH Tunnel
(Include a screenshot of your application running successfully in your local browser via the SSH tunnel)

Deliverables
Take screenshots of every step, and include it in your README.md.

When you're done with the project, destroy your entire infrastructure using the terraform destroy command.

