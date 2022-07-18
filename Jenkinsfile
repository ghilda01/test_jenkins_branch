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
    }
    stages {
        stage('Deployment') {
            when {
                branch 'prod'
            }
            steps {
                echo 'Deploying on prod'
            }
          when {
                branch 'preprod'
            }
            steps {
                echo 'Deploying on preprod'
            }
          when {
                branch 'staging'
            }
            steps {
                echo 'Deploying on staging'
            }
        }
    }
}
