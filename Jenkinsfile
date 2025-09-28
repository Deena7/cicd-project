pipeline {
  agent any
  tools {
    jdk 'jdk17'
    maven 'Maven3'
   }
  stages {
    stage('Checkout') {
      steps { git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/Deena7/cicd-project.git' }
    }
    stage('Build with Maven') {
      steps { sh 'mvn clean package -DskipTests' }
    }
    stage('SonarQube Analysis') {
      steps {
        withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
          sh "mvn sonar:sonar -Dsonar.login=${SONAR_TOKEN} -Dsonar.host.url=http://<EC2-2-IP>:9000"
        }
      }
    }
    stage('Docker Build & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh """
            docker login -u $USER -p $PASS
            docker build -t $USER/myapp:${BUILD_NUMBER} .
            docker push $USER/myapp:${BUILD_NUMBER}
          """
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh "kubectl --kubeconfig=$KUBECONFIG apply -f k8s/deployment.yaml"
        }
      }
    }
  }
}

