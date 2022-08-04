pipeline {
    agent {
        kubernetes {
            label "jenkins-worker-terraform-${UUID.randomUUID().toString()}"
            defaultContainer 'jnlp'
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: jnlp
      image: jenkins/jnlp-slave
      tty: true
      pull: always

    - name: terraform
      image: eu.gcr.io/somfy-protect-dev-master/jenkins-worker-terraform
      tty: true
'''
        }
    }
    environment {
        AWS_USER = ''
        GIT_URL = 'https://github.com/ghilda01/test_jenkins_branch'
        CREDENTIALS_ID_GIT = 'JenkinsGithub'
        JENKINS_JOB_PATH = 'Infra/cloud-infrastructure'
    }
    stages {
        stage('Deployment') {
            when {
                anyOf {
                    branch 'prod'
                    branch 'preprod'
                    branch 'dev'
                }
            }
            steps {
                withCredentials([[
                                         $class: 'AmazonWebServicesCredentialsBinding',
                                         credentialsId: "${env.BRANCH_NAME}_deployment_aws_user",
                                         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                 ]]) {
                    container('terraform') {
                        echo "Deploying on ${env.BRANCH_NAME}..."
                        sh '''terraform version'''
                        sh '''terraform init'''
                        sh '''terraform plan -out ${env.BRANCH_NAME}_${env.BUILD_NUMBER}'''
                        script {
                            input message: "Should we apply this plan?", ok: "Yes, we should."
                        }
                        sh '''terraform apply -input=false ${env.BRANCH_NAME}_${env.BUILD_NUMBER}'''
                    }
                }
            }
        }
    }
}
