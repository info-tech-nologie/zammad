node {
    def app
    def repoUrl = 'https://github.com/info-tech-nologie/zammad.git'
    def branchName = 'master'
    def imageTag = 'mohamedalirezgui/zammad-custom:latest' // votre image construite

    stage('Clone repository') {
        checkout([$class: 'GitSCM',
                  branches: [[name: branchName]],
                  userRemoteConfigs: [[url: repoUrl]]])
    }

    stage('Build Docker Image') {
        script {
            app = docker.build(imageTag)
        }
    }

    stage('Scan Image with Trivy') {
        script {
            try {
                sh 'trivy image --severity CRITICAL,HIGH --exit-code 1 --ignore-unfixed ' + imageTag
            } catch (err) {
                echo "Vulnérabilités critiques ou élevées détectées, mais le pipeline continue."
            }
        }
    }

    stage('Push Docker Image') {
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push()
        }
    }

    // Aucune étape de déploiement automatique
    echo 'Build et push terminés. Aucun déploiement automatique effectué.'
}