pipeline {
    agent {
        kubernetes  {
            inheritFrom 'pre'
            yaml '''
            spec:
              imagePullSecrets:
                - name: pre-nexus
            '''
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