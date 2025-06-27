pipeline {
    agent {
        kubernetes  {
            inheritFrom 'pre'
            yaml '''
            spec:
              imagePullSecrets:
                - name: nexus-pre
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