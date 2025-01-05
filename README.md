# **Detailed Documentation: Automating Deployment of a Sample TODO App Using CI/CD Pipeline**

## **Objective:**
The objective of this task was to automate the deployment of a sample TODO app using a CI/CD pipeline. The pipeline should be triggered upon merging changes to the `main` branch in the GitHub repository.

---

## **Tools and Technologies Used:**
- **GitHub**: For managing the code repository.
- **Docker**: For containerizing the application using a multi-stage Dockerfile.
- **Docker Hub**: For storing Docker images.
- **Docker Compose**: For easier deployment and service orchestration.
- **GitHub Actions**: For setting up the CI/CD pipeline.
- **Ubuntu Server**: For hosting the deployed application.

---

## **Steps Followed:**

### **Step 1: Forking the Repository**
1. Forked the provided repository to my personal GitHub account.
   - Repository URL: [https://github.com/bhupendrargoud/devops_todo.git](https://github.com/bhupendrargoud/devops_todo.git)
2. Cloned the forked repository to my local machine:
   ```bash
   git clone https://github.com/<your-username>/devops_todo.git
   ```
3. Made the necessary changes to the application, including updating the port definition to `3000`.

---

### **Step 2: Creating a Multi-Stage Dockerfile**
Created a multi-stage Dockerfile to optimize the build process.

**Dockerfile:**
```Dockerfile
# Stage 1: Build Stage
FROM node:16 as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM node:16-alpine
WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
CMD ["node", "server.js"]
```

**Explanation:**
- The **Build Stage** installs all dependencies and builds the application.
- The **Production Stage** uses a smaller image to run the built application.
- This approach reduces the size of the final Docker image and optimizes the build process.

---

### **Step 3: Setting Up Docker Compose**
Created a `docker-compose.yml` file for easier deployment of the application.

**docker-compose.yml:**
```yaml
version: '3.8'
services:
  app:
    image: <your-dockerhub-username>/devops_todo:latest
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
```

**Explanation:**
- The `app` service uses the Docker image from Docker Hub.
- The application is exposed on port `3000`.
- The environment variable `NODE_ENV` is set to `production`.

---

### **Step 4: Configuring GitHub Actions for CI/CD**
Set up a GitHub Actions workflow to automate the CI/CD process.

**GitHub Actions Workflow File (.github/workflows/deploy.yml):**
```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Log in to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build and push Docker image
      run: |
        docker build -t <your-dockerhub-username>/devops_todo:latest .
        docker push <your-dockerhub-username>/devops_todo:latest

    - name: Deploy application
      run: |
        ssh -o StrictHostKeyChecking=no ${{ secrets.SERVER_USER }}@${{ secrets.SERVER_IP }} "docker pull <your-dockerhub-username>/devops_todo:latest && docker-compose up -d"
```

**Explanation:**
- The workflow triggers on every push to the `main` branch.
- The pipeline:
  1. Checks out the code.
  2. Logs in to Docker Hub using secrets.
  3. Builds and pushes the Docker image to Docker Hub.
  4. Connects to the server via SSH and deploys the updated application using Docker Compose.

---

### **Step 5: Adding Secrets to GitHub**
Added the following secrets to the GitHub repository for secure storage of sensitive information:
- **DOCKER_USERNAME**: Docker Hub username.
- **DOCKER_PASSWORD**: Docker Hub password.
- **SERVER_USER**: SSH username for the server.
- **SERVER_IP**: Server IP address.

---

### **Step 6: Deployment Process**
Once changes are pushed to the `main` branch:
1. The CI/CD pipeline automatically builds the Docker image and pushes it to Docker Hub.
2. The server pulls the new image and redeploys the application using Docker Compose.

---

### **Verification**
Verified the deployment by accessing the application in the browser at:
```
http://<server-ip>:3000
```

---

### **Challenges Faced and Solutions**
| **Challenge**                     | **Solution**                                           |
|-----------------------------------|-------------------------------------------------------|
| Image pull issues on the server   | Ensured proper Docker login credentials were used.    |
| SSH connection issues             | Updated SSH configurations and added the server IP to known hosts. |
| Secrets management                | Used GitHub Actions secrets for secure credentials storage. |

---

### **Conclusion**
The automation of the TODO app deployment using a CI/CD pipeline was successfully implemented. The pipeline ensures that any changes merged to the `main` branch are automatically built, pushed to Docker Hub, and deployed to the server without manual intervention.

This process improves efficiency, reduces human error, and ensures consistent deployments.

