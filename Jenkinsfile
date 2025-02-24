pipeline {
    agent any
    
    environment {
        // Load Docker Hub credentials from Jenkins credentials store
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        // Define the image tag with build number
        IMAGE_TAG = "perni007/studentsform:${BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                // Remove previous artifacts and build a new WAR file
                sh 'rm -rf *.war'
                sh 'jar -cvf survey.war -C "src/main/webapp" .'     
                // Build the Docker image with the defined image tag
                sh "docker build -t ${IMAGE_TAG} ."
            }
        }

        stage('Login to Docker Hub') {
            steps {
                // Use Docker Hub credentials to log in
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh "echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin"
                }
            }
        }

        stage("Push image to Docker Hub") {
            steps {
                // Push the built Docker image to Docker Hub
                sh "docker push ${IMAGE_TAG}"
            }
        }

        stage("Deploying on Kubernetes") {
            steps {
                // Set the image for the Kubernetes deployment
                sh "kubectl set image deployment/homework2demo container-0=${IMAGE_TAG} -n default"
                // Restart the deployment to apply changes
                sh "kubectl rollout restart deploy homework2demo -n default"
            }
        }
    }

    post {
        always {
            // Logout from Docker Hub after the pipeline execution
            sh 'docker logout'
        }
    }
}
