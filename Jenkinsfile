pipeline {
  agent any

  environment {
    IMAGE_NAME = 'shivamraina66/multicloud'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build JAR') {
      steps {
        sh 'mvn -B -f springboot-app/pom.xml clean package'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'ls -lh springboot-app/target/'  // 👈 Debug check
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        }
      }
    }
    stage('Deploy via Ansible (Multi-Cloud)') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'azure-ssh', keyFileVariable: 'SSH_KEY')]) {
          sh '''
            ansible-playbook -i ansible/inventories/multi-cloud ansible/playbooks/deploy.yml \
              --extra-vars "image=${IMAGE_NAME}:${IMAGE_TAG}"
          '''
        }
      }
    }
  }
}