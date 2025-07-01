# Use an official Node.js runtime as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (if present) first
COPY package*.json ./

# Install application dependencies
RUN npm install --production

# Copy the rest of the application source code into the container
COPY . .

# Expose the port the Node.js application listens on
EXPOSE 3000

# Define the command to run the application when the container starts
CMD ["npm", "start"]
