pipeline {
    agent none
    environment {
        DOCKER = credentials('docker_hub')
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        env.AGENT_LABEL = 'prod'
                        env.TARGET_HOST = '44.199.191.179'
                    } else if (env.BRANCH_NAME == 'test') {
                        env.AGENT_LABEL = 'test'
                        env.TARGET_HOST = '13.220.7.237'
                    } else {
                        error "Unknown branch ${env.BRANCH_NAME}"
                    }
                }
            }
        }

        stage('Clone') {
            agent { label env.AGENT_LABEL }
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'git@github.com:sanyakarbyrator/doker-nginx-apache.git'
            }
        }

        stage('Docker Login') {
            agent { label env.AGENT_LABEL }
            steps {
                sh 'docker login -u "$DOCKER_USR" -p "$DOCKER_PSW"'
            }
        }

        stage('Build') {
            agent { label env.AGENT_LABEL }
            steps {
                sh '''
                    docker build -t sanyakarbyurator/apache_info:latest ./docker/apache
                    docker build -t sanyakarbyurator/nginx_info:latest ./docker/nginx
                '''
            }
        }

        stage('Push') {
            agent { label env.AGENT_LABEL }
            steps {
                sh '''
                    docker push sanyakarbyurator/apache_info:latest
                    docker push sanyakarbyurator/nginx_info:latest
                '''
            }
        }

        stage('Clean Images') {
            agent { label env.AGENT_LABEL }
            steps {
                sh 'docker image prune -af --filter "until=24h"'
            }
        }

        stage('Deploy') {
            agent { label env.AGENT_LABEL }
            steps {
                sshagent (credentials: ['ubuntu']) {
                    sh """
ssh -o StrictHostKeyChecking=no ubuntu@${env.TARGET_HOST} << 'EOF'
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
                    """
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
