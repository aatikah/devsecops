# For Detailed Step by Step Guide
You can find detailed step by step guide on creating this project on the Medium posts I created:

[**PART 1: Introduction and Prerequisites**](https://link.medium.com/9Dy53khoNQb).

---

# django.nV

This application is a forked repository known as django.nV. It is a deliberately vulnerable Django application developed by [nVisium](https://www.nvisium.com/). It serves as a practical tool for security professionals and developers to identify, understand, and mitigate common vulnerabilities within Django applications.

In this project, I am using the application to set up and simulate a DevSecOps project using docker and Jenkins

---

## Features

- **Purposeful Vulnerabilities**: Includes a range of security flaws commonly found in Django applications, offering a hands-on environment for learning and testing.
- **CI/CD Pipeline Integration**: Incorporates security scanning tools within the pipeline to ensure DevSecOps best practices.
- **Docker Support**: Easily containerized for consistent deployments.
- **Educational Resource**: Ideal for training sessions, workshops, and self-study to enhance security skills.

---

## System Requirements

- **Python**: Version 3.4 or higher.
- **Docker & Docker Compose**: Installed on your system.
- **Jenkins**: To execute the CI/CD pipeline.
- **Virtualenv**: For creating isolated Python environments.

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/aatikah/devsecops.git
cd devsecops
```

### 2. Run Using Docker
The Dockerfile is configured for containerizing the Django application. Key features include:

Installing Python dependencies.
Running database migrations during the build process.
Exposing the application on port 8000.

To build and run the application using Docker:

```sh
docker build -t django.nv .
docker run -p 8000:8000 django.nv
```
Access the application at http://127.0.0.1:8000/.

### 3. Local Environment Setup (Optional)
If you prefer to run the application without Docker:

- **Set Up Virtual Environment:**
```sh
pip install virtualenv
virtualenv -p python3 venv
source venv/bin/activate
```

- **Install Dependencies:**

```sh
pip install -r requirements.txt
```
- **Apply Migrations:**

```sh
python manage.py migrate
```
- **Run the Application:**

```sh
python manage.py runserver
```
## CI/CD Pipeline with Jenkins
The repository includes a Jenkinsfile for implementing a CI/CD pipeline with integrated security scans:

### Key Stages:
1. **Build:** Creates the Docker image using the provided Dockerfile.
2. **Security** Scans:
    - OWASP Dependency Check: Executes the owasp-dependency-check.sh script to scan for vulnerabilities in dependencies.
    - Gitleaks: Uses the .gitleaks.toml configuration file to scan for secrets in the codebase.
3. **Testing:** Runs the application tests.
4. **Deploy:** Pushes the Docker image to a registry and deploys the application.

---
### Security Tools

The Jenkinsfile  incorporates various stages of a CI/CD pipeline, including static analysis, vulnerability scanning, Docker image creation, and deployment. Here's a quick breakdown of the functionality:

1. **Agent Configuration:**
    - Specifies a **jenkins-slave** label for running the pipeline stages.
      
2. **Environment Variables:**

    - Sets variables like DOCKER_REGISTRY, DOCKER_IMAGE, and remoteHost for use in multiple stages.

3. **Stages:**

    - **Testing:** Confirms that the pipeline runs on the slave node.
    - **Gitleaks Scan:** Runs a Gitleaks scan for secrets in the repository, archives the report, and displays its contents.
      A .gitleaks.toml configuration file is included for scanning the repository for sensitive information. To run manually:

        ```sh
        gitleaks detect --config=.gitleaks.toml
        ```
    - **Dependency Check (SCA):** Uses OWASP Dependency-Check for software composition analysis, archives reports, and publishes HTML             output.
      The owasp-dependency-check.sh script performs dependency analysis to identify known vulnerabilities. To run the script manually:
        ```sh
        ./owasp-dependency-check.sh
        ```
    - **Bandit SAST:** Runs Bandit for Python static analysis, archives reports, and publishes HTML output.
    - **Docker Build and Push:** Builds a Docker image, logs in to Docker Hub, and pushes the image to the repository.
    - **Deployment to GCP:** Deploys the Docker image to a GCP VM via SSH, ensuring the container restarts automatically.
    - **OWASP ZAP DAST:** Runs a ZAP security scan on the deployed application, archives reports, and evaluates vulnerabilities.

---
### Key Features:

- **Error Handling:** Uses **|| true** and specific conditions to allow pipeline continuation despite failures.
- **Report Archiving:** Archives JSON and HTML reports for vulnerability and static analysis stages.
- **HTML Publishing:** Publishes HTML reports for easy visualization of scan results.
- **Parsing JSON Reports:** Extracts and logs details about vulnerabilities from JSON reports for both Dependency-Check and ZAP.

---
### Suggestions for Optimization:

- **Error Handling Consistency:** For ZAP high-risk vulnerabilities, you could use a more unified handling mechanism to fail or mark the build unstable based on severity.
- **Security Enhancements:** Remove leftover credentials securely. For example, ensure the Docker config cleanup step handles all cases.
- **Performance:** Parallelize independent stages (e.g., SAST, Dependency Check) to reduce execution time.



