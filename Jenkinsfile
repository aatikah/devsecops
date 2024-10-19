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
    stage ('Gitleak scan'){
      steps{
        script{
          sh '''
          docker run --rm -v $(pwd):/path -v $(pwd)/.gitleaks.toml:/.gitleaks.toml zricethezav/gitleaks:latest detect --source /path --config /.gitleaks.toml --report-format json --report-path /path/gitleaks-report.json || true
          '''
        }
      }
    }
    
  }
}
