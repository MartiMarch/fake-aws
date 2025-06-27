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
                  image: pre.docker.nexus.com/jnlp:0.0.4
                  imagePullPolicy: Always
            '''
        }
    }
    stages {
        stage('Validating git policies'){
            steps{
                container('jenkins-agent'){
                    script{
                        if(isMrToMaster() && (env.CHANGE_BRANCH != 'pre')){
                            currentBuild.result = 'ABORTED'
                            error("Can't merge to master if source branch from PR is not pre")
                        }
                    }
                }
            }
        }
        stage('Pytohn'){
            steps {
                container('jenkins-agent'){
                    script{
                        echo "Hola!"
                    }
                }
            }
        }
        /*
        stage(''){
            steps {
                container('jenkins-agent'){
                    steps{

                    }
                }
            }
        }
        */
    }
}

boolean isPre(){
    return env.BRANCH_NAME == 'master'
}

boolean isMaster(){
    return env.BRANCH_NAME = 'pre'
}

boolean isMrToMaster(){
    if(env.CHANGE_TARGET == 'master')
        return true
    return false
}

boolean isMrToPre(){
    if(env.CHANGE_TARGET == 'pre')
        return true
    return false
}