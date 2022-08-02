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

    - name: monorepo
      image: eu.gcr.io/somfy-protect-dev-master/jenkins-worker-robot
      tty: true
      pull: always
'''
        }
    }
    environment {
        GIT_URL = 'https://github.com/ghilda01/test_jenkins_branch'
        CREDENTIALS_ID_GIT = 'JenkinsGithub'
        JENKINS_JOB_PATH = 'Infra/cloud-infrastructure'
        AWS_USER = null
    }
    stages {
        stage('Check environment') {
            when {
                anyOf {
                    branch 'prod'
                    branch 'preprod'
                    branch 'dev'
                }
            }
            steps {
                script {
                    AWS_USER = "aws_deployment_user_${env.BRANCH_NAME}"
                }
            }
        }
        stage('Deployment') {
            when {
                expression {
                    return ${AWS_USER} != null
                }
            }
            steps {
                echo "Deploying on ${env.BRANCH_NAME}..."
                echo 'docker run -i -t hashicorp/terraform:latest plan'
                script {
                    input message: "Should we continue with ${AWS_USER}?", ok: "Yes, we should."
                }
                echo "terraform apply"
            }
        }
    }
}
