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
    
    stage ('Source Composition Analysis With OWASP Dependecy Check'){
      steps{
        script{
          sh 'rm dependency-check-report*  || true'
          sh 'wget "https://raw.githubusercontent.com/aatikah/devsecops/refs/heads/master/owasp-dependency-check.sh"'
          sh 'bash owasp-dependency-check.sh'

          //Archive the report as artifact
          archiveArtifacts artifacts: 'dependency-check-report.json, dependency-check-report.html, dependency-check-report.xml', allowEmptyArchive: true
          // Publish HTML Report
            publishHTML(target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: false,
                        keepAll: true,
                        reportDir: '.',
                        reportFiles: 'dependency-check-report.html',
                        reportName: 'OWASP Dependency Checker Report'
                    ])
          // Parse JSON report to check for issues
                if (fileExists('dependency-check-report.json')) {
                    def jsonReport = readJSON file: 'dependency-check-report.json'
                    def vulnerabilities = jsonReport.dependencies.collect { it.vulnerabilities ?: [] }.flatten()
                    def highVulnerabilities = vulnerabilities.findAll { it.cvssv3?.baseScore >= 7 }
                    echo "OWASP Dependency-Check found ${vulnerabilities.size()} vulnerabilities, ${highVulnerabilities.size()} of which are high severity (CVSS >= 7.0)"
                } else {
                    echo "Dependency-Check JSON report not found. The scan may have failed."
                }
          
        }
        
      }
    }
    
  }
}
