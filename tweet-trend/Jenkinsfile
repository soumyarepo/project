pipeline {
    agent {
        node {
             label 'maven' 
        }
    }

    stages {
        stage('GitCheckout') {
            steps {
                git branch: 'main', url: 'https://github.com/ravdy/tweet-trend.git'
                sh 'ls -lrta'
            }
        }
    }
}