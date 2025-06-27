pipeline {
    agent {
        kubernetes  {
            inheritFrom 'pre'
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              hostAliases:
                - ip: "192.168.2.80"
                  hostnames:
                  - "pre.jenkins.com"
              imagePullSecrets:
                - name: nexus-pre
              containers:
                - name: jnlp
                  image: pre.docker.nexus.com/jnlp:0.0.2
                  imagePullPolicy: Always
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