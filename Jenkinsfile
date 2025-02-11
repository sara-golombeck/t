// // // pipeline {
// // //     agent any
// // //     tools {
// // //         maven 'Maven-3.6.2'
// // //         jdk 'JAVA_8'
// // //     }
    
// // //     triggers {
// // //         githubPush() 
// // //     }
    
// // //     stages {
// // //         stage('Install') {
// // //             steps {
// // //                 configFileProvider([configFile(fileId: 'Artifactory-Settings', variable: 'MAVEN_SETTINGS')]) {
// // //                     sh "mvn -s $MAVEN_SETTINGS clean install"
// // //                 }
// // //             }
// // //         }
// // //     }
// // // }


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

// //         stage('Test Docker Image') {
// //             steps {
// //                 script {
// //                     // Clean any existing thumbnails
// //                     sh "rm -f examples/*_thumb.jpg || true"
                    
// //                     // Run the docker image with default size
// //                     sh "docker run -v \$(pwd)/examples:/pics thumbnailer:latest"
                    
// //                     // Verify JPEG thumbnail was created
// //                     sh """
// //                         if [ ! -f examples/jenkins1_thumb.jpg ]; then
// //                             echo "JPEG thumbnail was not created!"
// //                             exit 1
// //                         fi
// //                     """
                    
// //                     // Verify TIFF is not supported (as per checkpoint requirement)
// //                     sh """
// //                         if [ -f examples/jenkins2_thumb.jpg ]; then
// //                             echo "TIFF thumbnail was created, but should not be supported yet!"
// //                             exit 1
// //                         fi
// //                     """
                    
// //                     // Test with different thumbnail size
// //                     sh "rm -f examples/*_thumb.jpg"
// //                     sh "docker run -v \$(pwd)/examples:/pics -e TN_SIZE=200 thumbnailer:latest"
                    
// //                     // Verify thumbnail with custom size was created
// //                     sh "test -f examples/jenkins1_thumb.jpg"
// //                 }
// //             }
// //         }
// //     }
    
// //     post {
// //         always {
// //             // Cleanup
// //             sh "rm -f examples/*_thumb.jpg || true"
// //         }
// //     }
// // }


// pipeline {
//     agent any
//     tools {
//         maven 'Maven-3.6.2'
//         jdk 'JAVA_8'
//     }
    
//     environment {
//         // הוספת משתנה סביבה לשם ה-image והתג שלו
//         DOCKER_IMAGE = 'thumbnailer'
//         DOCKER_TAG = '1.0-SNAPSHOT'
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
//                     chmod 777 examples
//                     // Clean any existing thumbnails
//                     sh "rm -f examples/*_thumb.jpg || true"
                    
//                     // Run the docker image with default size - שים לב לשינוי בשם ה-image והתג
//                     sh "docker run -v \$(pwd)/examples:/pics ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    
//                     // Verify JPEG thumbnail was created
//                     sh """
//                         if [ ! -f examples/jenkins1_thumb.jpg ]; then
//                             echo "JPEG thumbnail was not created!"
//                             exit 1
//                         fi
//                     """
                    
//                     // Verify TIFF is not supported
//                     sh """
//                         if [ -f examples/jenkins2_thumb.jpg ]; then
//                             echo "TIFF thumbnail was created, but should not be supported yet!"
//                             exit 1
//                         fi
//                     """
                    
//                     // Test with different thumbnail size
//                     sh "rm -f examples/*_thumb.jpg"
//                     sh "docker run -v \$(pwd)/examples:/pics -e TN_SIZE=200 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    
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
        DOCKER_IMAGE = 'thumbnailer'
        DOCKER_TAG = '1.0-SNAPSHOT'
    }
    
    options {
        durabilityHint('PERFORMANCE_OPTIMIZED')
        timeout(time: 30, unit: 'MINUTES')
    }
    
    triggers {
        githubPush()
    }
    
    stages {
        stage('Prepare Environment') {
            steps {
                script {
                    sh """
                        echo "Checking workspace permissions and structure:"
                        ls -la
                        
                        echo "Setting up required permissions:"
                        chmod -R 755 .
                        
                        echo "Ensuring examples directory exists and has correct permissions:"
                        mkdir -p examples
                        chmod 777 examples
                        
                        echo "Cleaning any existing thumbnails:"
                        rm -f examples/*_thumb.jpg || true
                        
                        echo "Current directory structure:"
                        ls -la examples/
                    """
                }
            }
        }

        stage('Install') {
            steps {
                script {
                    sh 'echo "Maven home: $MAVEN_HOME"'
                    sh 'echo "Java home: $JAVA_HOME"'
                    
                    configFileProvider([configFile(fileId: 'Artifactory-Settings', variable: 'MAVEN_SETTINGS')]) {
                        sh """
                            echo "Using Maven settings from: $MAVEN_SETTINGS"
                            MAVEN_OPTS='-Xmx1024m' mvn -s $MAVEN_SETTINGS clean install
                        """
                    }
                }
            }
        }

        stage('Test Docker Image') {
            steps {
                script {
                    try {
                        // ניקוי קונטיינרים קודמים אם קיימים
                        sh """
                            echo "Cleaning up any existing containers..."
                            docker ps -a | grep ${DOCKER_IMAGE} && docker rm -f \$(docker ps -a | grep ${DOCKER_IMAGE} | awk '{print \$1}') || true
                        """
                        
                        // בדיקת הרשאות וסטטוס התיקייה
                        sh """
                            echo "Current working directory:"
                            pwd
                            
                            echo "Contents of examples directory before test:"
                            ls -la examples/
                            
                            echo "Cleaning existing thumbnails:"
                            rm -f examples/*_thumb.jpg || true
                        """
                        
                        // הרצת הדוקר עם לוגים מורחבים
                        sh """
                            echo "Running Docker container with verbose logging..."
                            docker run -v \$(pwd)/examples:/pics \
                                -e DEBUG=true \
                                --user \$(id -u):\$(id -g) \
                                --name test_container_${BUILD_NUMBER} \
                                ${DOCKER_IMAGE}:${DOCKER_TAG}
                        """
                        
                        // בדיקת לוגים של הקונטיינר
                        sh """
                            echo "Docker container logs:"
                            docker logs test_container_${BUILD_NUMBER}
                            
                            echo "Contents of examples directory after Docker run:"
                            ls -la examples/
                        """
                        
                        // בדיקת יצירת ה-thumbnail
                        sh """
                            if [ ! -f examples/jenkins1_thumb.jpg ]; then
                                echo "ERROR: JPEG thumbnail was not created!"
                                exit 1
                            else
                                echo "SUCCESS: JPEG thumbnail was created successfully!"
                            fi
                        """
                        
                        // בדיקת תמיכה ב-TIFF
                        sh """
                            if [ -f examples/jenkins2_thumb.jpg ]; then
                                echo "ERROR: TIFF thumbnail was created, but should not be supported yet!"
                                exit 1
                            else
                                echo "SUCCESS: TIFF files are correctly not supported."
                            fi
                        """
                        
                        // בדיקה עם גודל thumbnail מותאם
                        sh """
                            echo "Testing custom thumbnail size..."
                            rm -f examples/*_thumb.jpg
                            docker run -v \$(pwd)/examples:/pics \
                                -e TN_SIZE=200 \
                                -e DEBUG=true \
                                --user \$(id -u):\$(id -g) \
                                --name test_container_custom_${BUILD_NUMBER} \
                                ${DOCKER_IMAGE}:${DOCKER_TAG}
                                
                            if [ ! -f examples/jenkins1_thumb.jpg ]; then
                                echo "ERROR: Custom size thumbnail was not created!"
                                exit 1
                            else
                                echo "SUCCESS: Custom size thumbnail was created successfully!"
                            fi
                        """
                        
                    } catch (Exception e) {
                        echo "Error occurred: ${e.getMessage()}"
                        throw e
                    } finally {
                        // ניקוי קונטיינרים
                        sh """
                            echo "Cleaning up test containers..."
                            docker rm -f test_container_${BUILD_NUMBER} || true
                            docker rm -f test_container_custom_${BUILD_NUMBER} || true
                        """
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // ניקוי סופי
                sh """
                    echo "Final cleanup..."
                    rm -f examples/*_thumb.jpg || true
                    docker ps -a | grep ${DOCKER_IMAGE} && docker rm -f \$(docker ps -a | grep ${DOCKER_IMAGE} | awk '{print \$1}') || true
                """
            }
        }
        success {
            echo "Build completed successfully!"
        }
        failure {
            echo "Build failed! Check the logs for details."
        }
    }
}