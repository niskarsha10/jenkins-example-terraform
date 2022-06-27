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
    stage('terraform-init') {
      steps {
        withAWS(credentials: 'aadi_aws', region: 'us-east-2') {
          sh '''
           terraform init
         '''
         }
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
          tfsec . --no-color
        '''
      }
    }
	  stage('custom checks') {
	    steps {
	      sh '''
	       ---
               checks:
               - code: CUS001
                 description: Ensure the ami and azs 
                 impact: checks the ami and azs
                 resolution: put the given ami and azs ap-south-1a and ap-south-1b
                 requiredTypes:
                 - resource
                 requiredLabels:
                 - aws_instance
                 severity: HIGH
                 matchSpec:
                   action: or
                   predicateMatchSpec:
                     - action: and
                     predicateMatchSpec:
                       - name: ami
                       action: contains
                       value: ami-005e54dee72cc1d00
                       - name: availability_zone
                       action: isAny
                       value:
                         - ap-south-1a
                         - ap-south-1b
               errorMessage: The required ami or azs was missing
               relatedLinks:
               - http://internal.acmecorp.com/standards/aws/tagging.html
             '''
	    }
	  }
		    
    stage('TF lint') {
           agent {
               docker {
                   image "ghcr.io/terraform-linters/tflint"
                   args '-i --entrypoint='
                 }
           }
           steps {
	     sh '''
               tflint . --no-color
             '''
	   }
    }
		 
      stage('terraform-apply-and-destroy') {
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
