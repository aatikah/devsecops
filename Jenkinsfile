pipeline{
  agent {
    label 'jenkins-slave'
  }
  stages{
    stage('Testing'){
      steps {
        script{
          sh 'echo "Hello from Slave Node"'
        }
      }
    }
    
  }
}
