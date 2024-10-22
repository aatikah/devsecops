pipeline{
  agent {
    label 'jenkins-slave'
  }
  environment{
    DOCKER_REGISTRY = 'https://index.docker.io/v1/'
    DOCKER_IMAGE = 'aatikah/django-app'
    remoteHost = '10.0.1.4'
    
  }
  stages{
    
    stage('Testing'){
      steps {
        script{
          sh 'echo "Hello from Slave Node"'
        }
      }
    }
    stage ('Gitleak scan'){
      steps{
        script{ 
          // Pull and run the Gitleaks Docker Image with a custom config file
          sh '''
          docker run --rm -v $(pwd):/path -v $(pwd)/.gitleaks.toml:/.gitleaks.toml zricethezav/gitleaks:latest detect --source /path --config /.gitleaks.toml --report-format json --report-path /path/gitleaks-report.json || true
          '''
          // Archive the report as an Artifacts
          archiveArtifacts artifacts: 'gitleaks-report.json', allowEmptyArchive: true
          
          // Display the contents of the report in a separate step
          script{
            echo "Gitleaks Report:"
            sh 'cat gitleaks-report.json || echo "Report not found"'
          }
        }
      }
    }
    
    //OWASP AND BANDIT

    stage ('Build and Push Image to DockerHub'){
      steps{
        script{
          // Wrap the commands with the function withCredential to securely login to the docker account
          withCredentials([usernamePassword(credentialsId:'DOCKER_CREDENTIAL', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]){
            // Build the Docker Image
            sh 'docker build -t ${DOCKER_IMAGE} .'
            
            // Login to Docker Repo
            sh '''
              set +x
                echo "$DOCKER_PASSWORD" | docker login $DOCKER_REGISTRY -u "$DOCKER_USERNAME" --password-stdin
              set -x
            '''
            // Push Image to DockerHub
            sh 'docker push ${DOCKER_IMAGE}'
            
            // Clean up by removing ledtover credentials
            sh 'rm -f /home/jenkins/.docker/config.json'
          }
        }
      }
    }

     stage('Deploy to GCP VM') {
    steps {
        script {
            def remoteUser = 'jenkins-slave'
	          def dockerImage = 'aatikah/django-app'
            
            sshagent(['MASTER_PRIVATE_KEY']) {
                // Stop and remove the old container if it existS
                sh """
                    ssh -o StrictHostKeyChecking=no ${remoteUser}@${remoteHost} '
                        container_id=\$(docker ps -q --filter ancestor=${dockerImage})
                        if [ ! -z "\$container_id" ]; then
                            docker stop \$container_id
                            docker rm \$container_id
                        fi
                '
                """
                
                // Pull the latest image and run the new container
                sh """
                    ssh -o StrictHostKeyChecking=no ${remoteUser}@${remoteHost} '
                        docker pull ${dockerImage} && 
                        docker run -d --restart unless-stopped -p 8000:8000 --name my-task-app ${dockerImage}
                    '
                """
                
                // Verify the deployment
                sh """
                    ssh -o StrictHostKeyChecking=no ${remoteUser}@${remoteHost} '
                        if docker ps | grep -q ${dockerImage}; then
                            echo "Deployment successful"
                        else
                            echo "Deployment failed"
                            exit 1
                        fi
                    '
                """
            }
        }
    }
}
    
  }
}
