pipeline {
    agent any

    environment {
        REGISTRY = 'your-dockerhub-username'
        IMAGE_NAME = 'zammad-custom'
        IMAGE_TAG = 'latest'
        IMAGE_FULL_NAME = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
        KUBE_NAMESPACE = 'zammad-namespace'
        KUBE_CONTEXT = 'your-k8s-context' // si vous utilisez plusieurs contextes
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_FULL_NAME}")
                }
            }
        }

        stage('Scan Image with Trivy') {
            steps {
                script {
                    // Assurez-vous que Trivy est installé dans l'agent Jenkins ou utilisez une image avec Trivy
                    sh """
                    trivy image --exit-code 1 --severity CRITICAL,HIGH ${IMAGE_FULL_NAME}
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_FULL_NAME}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-credentials', contextName: "${KUBE_CONTEXT}"]) {
                    sh "kubectl apply -f k8s/deployment.yaml -n ${KUBE_NAMESPACE}"
                    sh "kubectl apply -f k8s/service.yaml -n ${KUBE_NAMESPACE}"
                }
            }
        }
    }
}
