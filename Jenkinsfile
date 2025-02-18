pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = "localhost:5000"
    }
    
    stages {
        stage('Build and Push Images') {
            steps {
                script {
                    def apps = ['http-web-app', 'https-web-app', 'websockets-web-app', 'wss-web-app']
                    
                    for (app in apps) {
                        dir("apps/${app}") {
                            def imageName = "${DOCKER_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                            
                            // Build the Docker image
                            sh "docker build -t ${imageName} ."
                            
                            // Push the image to the local registry
                            sh "docker push ${imageName}"
                        }
                    }
                }
            }
        }
        
        stage('Update Docker Compose') {
            steps {
                script {
                    def composeFile = readFile('apps/docker-compose.yaml')
                    def yamlData = readYaml text: composeFile
                    
                    def apps = ['http-web-app', 'https-web-app', 'websockets-web-app', 'wss-web-app']
                    
                    for (app in apps) {
                        yamlData.services[app].image = "${DOCKER_REGISTRY}/${app}:${env.BUILD_NUMBER}"
                        delete yamlData.services[app].build
                    }
                    
                    writeYaml file: 'apps/docker-compose.yaml', data: yamlData
                }
            }
        }
        
        stage('Deploy') {
            steps {
                dir('apps') {
                    sh 'docker-compose up -d'
                }
            }
        }
    }
}