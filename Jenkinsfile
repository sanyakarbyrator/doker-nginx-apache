pipeline {
    agent any

    environment {
        DOCKER = credentials('docker_hub')
    }

    stages {
        stage('Clone') {
            steps {
                git url: 'git@github.com:sanyakarbyrator/doker-nginx-apache.git', branch: 'main'
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

	stage('Del') {
	    steps {
		sh 'docker image prune -af --filter "until=24h"'
	    }
	}


        stage('Deploy') {
            steps {
                sshagent (credentials: ['ubuntu']) {
                    sh '''
			ssh -o StrictHostKeyChecking=no ubuntu@3.235.160.170 << 'EOF'
			docker network create --driver bridge task16

			docker pull sanyakarbyurator/apache_info:latest
			docker pull sanyakarbyurator/nginx_info:latest

			docker stop apache_info
			docker rm -f apache_info
			docker run -d --name apache_info --network task16 -p 8888:8888 sanyakarbyurator/apache_info:latest

			docker stop nginx_info
			docker rm -f nginx_info
			docker run -d --name nginx_info --network task16  -p 80:80 -p 443:443 sanyakarbyurator/nginx_info:latest

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
