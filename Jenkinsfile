pipeline {
    agent {
        kubernetes {
            label "jenkins-worker-robot-${UUID.randomUUID().toString()}"
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
      image: hashicorp/terraform
      tty: true
      pull: always
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
                echo "Deploying on ${env.BRANCH_NAME}..."
                withCredentials([[
                                         $class: 'AmazonWebServicesCredentialsBinding',
                                         credentialsId: "${env.BRANCH_NAME}_deployment_aws_user",
                                         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                 ]]) {
                    sh '''terraform plan'''
                    script {
                        input message: "Should we continue with ${AWS_ACCESS_KEY_ID}?", ok: "Yes, we should."
                    }
                    echo "terraform apply"
                }
            }
        }
    }
}
