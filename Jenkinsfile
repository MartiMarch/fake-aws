pipeline {
    agent {
        kubernetes  {
            inheritFrom 'pre'
        }
    }
    stages {
        stage('Hello world'){
            steps {
                echo "Hola!"
            }
        }
    }
}