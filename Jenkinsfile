pipeline {
    agent any
    tools {
        maven 'Maven-3.6.2'
        jdk 'JAVA_8'
    }
    
    triggers {
        githubPush() 
    }
    
    stages {
        stage('Build and Deploy') {
            steps {
                configFileProvider([configFile(fileId: 'Artifactory-Settings', variable: 'MAVEN_SETTINGS')]) {
                    sh "mvn -s $MAVEN_SETTINGS clean install"
                }
            }
        }
    }
}