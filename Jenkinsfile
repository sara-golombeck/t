pipeline {
    agent any
    
    tools {
        maven 'Maven-3.6.2'
        jdk 'JAVA_8'
    }
    
    environment {
        DOCKER_IMAGE = 'thumbnailer'
        DOCKER_TAG = '1.0-SNAPSHOT'
    }
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Install') {
            steps {
                configFileProvider([configFile(fileId: 'Jenkins-Artifactory', variable: 'MAVEN_SETTINGS')]) {
                    sh "mvn -U-s $MAVEN_SETTINGS clean install"
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                script {
                    sh 'docker rm -f thumbnailer || true'
                    
                    sh """
                        docker run --name thumbnailer \
                            -v /home/ubuntu/examples:/pics \
                            ${DOCKER_IMAGE}:${DOCKER_TAG} \
                            ls /pics
                    """
                }
            }
        }
    }
    
    post {
        always {
            // ניקוי בסיום
            sh 'docker rm -f thumbnailer || true'
        }
    }
}
