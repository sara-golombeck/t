// // pipeline {
// //     agent any
// //     tools {
// //         maven 'Maven-3.6.2'
// //         jdk 'JAVA_8'
// //     }
    
// //     triggers {
// //         githubPush() 
// //     }
    
// //     stages {
// //         stage('Install') {
// //             steps {
// //                 configFileProvider([configFile(fileId: 'Artifactory-Settings', variable: 'MAVEN_SETTINGS')]) {
// //                     sh "mvn -s $MAVEN_SETTINGS clean install"
// //                 }
// //             }
// //         }
// //     }
// // }


// pipeline {
//     agent any
//     tools {
//         maven 'Maven-3.6.2'
//         jdk 'JAVA_8'
//     }
    
//     triggers {
//         githubPush() 
//     }
    
//     stages {
//         stage('Install') {
//             steps {
//                 configFileProvider([configFile(fileId: 'Artifactory-Settings', variable: 'MAVEN_SETTINGS')]) {
//                     sh "mvn -s $MAVEN_SETTINGS clean install"
//                 }
//             }
//         }

//         stage('Test Docker Image') {
//             steps {
//                 script {
//                     // Clean any existing thumbnails
//                     sh "rm -f examples/*_thumb.jpg || true"
                    
//                     // Run the docker image with default size
//                     sh "docker run -v \$(pwd)/examples:/pics thumbnailer:latest"
                    
//                     // Verify JPEG thumbnail was created
//                     sh """
//                         if [ ! -f examples/jenkins1_thumb.jpg ]; then
//                             echo "JPEG thumbnail was not created!"
//                             exit 1
//                         fi
//                     """
                    
//                     // Verify TIFF is not supported (as per checkpoint requirement)
//                     sh """
//                         if [ -f examples/jenkins2_thumb.jpg ]; then
//                             echo "TIFF thumbnail was created, but should not be supported yet!"
//                             exit 1
//                         fi
//                     """
                    
//                     // Test with different thumbnail size
//                     sh "rm -f examples/*_thumb.jpg"
//                     sh "docker run -v \$(pwd)/examples:/pics -e TN_SIZE=200 thumbnailer:latest"
                    
//                     // Verify thumbnail with custom size was created
//                     sh "test -f examples/jenkins1_thumb.jpg"
//                 }
//             }
//         }
//     }
    
//     post {
//         always {
//             // Cleanup
//             sh "rm -f examples/*_thumb.jpg || true"
//         }
//     }
// }


pipeline {
    agent any
    tools {
        maven 'Maven-3.6.2'
        jdk 'JAVA_8'
    }
    
    environment {
        // הוספת משתנה סביבה לשם ה-image והתג שלו
        DOCKER_IMAGE = 'thumbnailer'
        DOCKER_TAG = '1.0-SNAPSHOT'
    }
    
    triggers {
        githubPush() 
    }
    
    stages {
        stage('Install') {
            steps {
                configFileProvider([configFile(fileId: 'Artifactory-Settings', variable: 'MAVEN_SETTINGS')]) {
                    sh "mvn -s $MAVEN_SETTINGS clean install"
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    chmod 777 examples
                    // Clean any existing thumbnails
                    sh "rm -f examples/*_thumb.jpg || true"
                    
                    // Run the docker image with default size - שים לב לשינוי בשם ה-image והתג
                    sh "docker run -v \$(pwd)/examples:/pics ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    
                    // Verify JPEG thumbnail was created
                    sh """
                        if [ ! -f examples/jenkins1_thumb.jpg ]; then
                            echo "JPEG thumbnail was not created!"
                            exit 1
                        fi
                    """
                    
                    // Verify TIFF is not supported
                    sh """
                        if [ -f examples/jenkins2_thumb.jpg ]; then
                            echo "TIFF thumbnail was created, but should not be supported yet!"
                            exit 1
                        fi
                    """
                    
                    // Test with different thumbnail size
                    sh "rm -f examples/*_thumb.jpg"
                    sh "docker run -v \$(pwd)/examples:/pics -e TN_SIZE=200 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    
                    // Verify thumbnail with custom size was created
                    sh "test -f examples/jenkins1_thumb.jpg"
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup
            sh "rm -f examples/*_thumb.jpg || true"
        }
    }
}