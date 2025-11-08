pipeline {
  agent any
  environment {
    IMAGE_NAME = 'shivamraina/multicloud'
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build') {
      steps {
        sh 'mvn -B -DskipTests=false -f springboot-app/pom.xml clean package'
      }
    }
    stage('Unit Tests') {
      steps { sh 'mvn -f springboot-app/pom.xml test' }
    }
    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }
    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
          sh 'echo $PASS | docker login -u $USER --password-stdin'
          sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        }
      }
    }
    stage('Deploy via Ansible') {
      steps {
        sh "ansible-playbook -i ansible/inventories/multi-cloud ansible/playbooks/deploy.yml --extra-vars \"image=${IMAGE_NAME}:${IMAGE_TAG}\""
      }
    }
  }
  post {
    success { echo 'Pipeline succeeded' }
    failure { echo 'Pipeline failed' }
  }
}
