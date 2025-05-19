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
                sh 'sudo ocker login -u "$DOCKER_USR" -p "$DOCKER_PSW"'
            }
        }

        stage('Build') {
            agent { label env.AGENT_LABEL }
            steps {
                sh '''
                    sudo docker build -t sanyakarbyurator/apache_info:latest ./docker/apache
                    sudo docker build -t sanyakarbyurator/nginx_info:latest ./docker/nginx
                '''
            }
        }

        stage('Push') {
            agent { label env.AGENT_LABEL }
            steps {
                sh '''
                    sudo docker push sanyakarbyurator/apache_info:latest
                    sudo docker push sanyakarbyurator/nginx_info:latest
                '''
            }
        }

        stage('Clean Images') {
            agent { label env.AGENT_LABEL }
            steps {
                sh 'sudo docker system prune -af --filter "until=24h"'
            }
        }

        stage('Deploy') {
            agent { label env.AGENT_LABEL }
            steps {
                sshagent (credentials: ['tututu']) {
                    sh """
ssh -o StrictHostKeyChecking=no ubuntu@${env.TARGET_HOST} << 'EOF'
sudo docker network create --driver bridge task16
sudo docker pull sanyakarbyurator/apache_info:latest
sudo docker pull sanyakarbyurator/nginx_info:latest
sudo docker stop apache_info 
sudo docker rm -f apache_info 
sudo docker run -d --name apache_info --network task16 -p 8888:8888 sanyakarbyurator/apache_info:latest
sudo docker stop nginx_info
sudo docker rm -f nginx_info 
sudo docker run -d --name nginx_info --network task16 -p 80:80 -p 443:443 sanyakarbyurator/nginx_info:latest
sudo docker image prune -af --filter "until=24h"
EOF
                    """
                }
            }
        }
    }

}
