pipeline {
    agent {
        label env.BRANCH_NAME == 'main' ? 'prod' : 'test'
    }

    environment {
        DOCKER = credentials('docker_hub')
        TARGET_HOST = env.BRANCH_NAME == 'main' ? '3.235.53.185' : 'IP_TEST_SER'
    }

    stages {
        stage('Clone') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'git@github.com:sanyakarbyrator/doker-nginx-apache.git'
            }
        }

        stage('Docker Login') {
            steps {
                sh 'docker login -u "$DOCKER_USR" -p "$DOCKER_PSW"'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    docker build -t sanyakarbyurator/apache_info:latest ./docker/apache
                    docker build -t sanyakarbyurator/nginx_info:latest ./docker/nginx
                '''
            }
        }

        stage('Push') {
            steps {
                sh '''
                    docker push sanyakarbyurator/apache_info:latest
                    docker push sanyakarbyurator/nginx_info:latest
                '''
            }
        }

        stage('Clean Images') {
            steps {
                sh 'docker image prune -af --filter "until=24h"'
            }
        }

        stage('Deploy') {
            steps {
                sshagent (credentials: ['ubuntu']) {
                    sh '''
ssh -o StrictHostKeyChecking=no ubuntu@$TARGET_HOST << 'EOF'
docker network create --driver bridge task16 || true
docker pull sanyakarbyurator/apache_info:latest
docker pull sanyakarbyurator/nginx_info:latest
docker stop apache_info || true
docker rm -f apache_info || true
docker run -d --name apache_info --network task16 -p 8888:8888 sanyakarbyurator/apache_info:latest
docker stop nginx_info || true
docker rm -f nginx_info || true
docker run -d --name nginx_info --network task16 -p 80:80 -p 443:443 sanyakarbyurator/nginx_info:latest
docker image prune -af --filter "until=24h"
EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            sh 'docker image prune -af --filter "until=24h"'
        }
    }
}
