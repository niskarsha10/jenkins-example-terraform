pipeline {
  agent any
  options {
    skipDefaultCheckout(true)
  }
  stages{
    stage('clean workspace') {
      steps {
        cleanWs()
      }
    }
    stage('checkout') {
      steps {
        checkout scm
      }
    }
    stage('tfsec') {
      agent {
        docker { 
          image 'tfsec/tfsec-ci' 
          reuseNode true
        }
      }
      steps {
        sh '''
	  terraform init
          tfsec . --no-color
        '''
      }
    }
    stage('terraform') {
      steps {
        withAWS(credentials: 'aadi_aws', region: 'us-east-2') {  
          sh '''
	   terraform apply -auto-approve -no-color
	   terraform destroy -auto-approve -no-color
         '''
         }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
  }
}
