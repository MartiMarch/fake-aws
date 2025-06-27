pipeline {
    agent {
        kubernetes  {
            inheritFrom 'pre'
            yaml '''
            spec:
              containers:
                - name: jnlp
                  image: pre.docker.nexus.com/jnlp:0.0.0
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