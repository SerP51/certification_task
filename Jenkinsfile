pipeline {
    agent any
    
    environment {
        buidingVM = ''
        prodVM = ''
        DOCKERHUB_CREDENTIALS=credentials('6fe52247-3831-4a06-a0c7-21fc756e4380')
    }

    tools {
        terraform 'terraform17'
    }

    stages {
        stage("Terraform Init") {
            steps {
                sh 'terraform init'
            }
        }
        stage("Terraform plan") {
            steps {
                sh 'terraform plan'
            }
        }
        stage("Terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
            }
        }
        stage("Wait VMs boot"){
            steps {
                echo "Wait 40 sec VMs boot..."
                sh 'sleep 40'
            }
        }
        stage("Get prodVM and buidingVM IPs") {
            steps {
                script {
                    buidingVM = sh( script: 'terraform output --raw buildingVM_IP',
                                    returnStdout: true).trim()
                    echo "buidingVM: ${buidingVM}"
                    prodVM = sh( script: 'terraform output --raw prodVM_IP',
                                    returnStdout: true).trim()
                    echo "prodVM: ${prodVM}"
                }
            }
        }
        stage("Add Hosts to ansible inventory") {
            steps {
                script {
                   def data = "${buidingVM} ansible_connection=ssh ansible_user=jenkins\n${prodVM} ansible_connection=ssh ansible_user=jenkins\n"
                   writeFile(file: 'hostsAnsible', text: data)
               }
            }
        }
        stage("Add ssh keys to known_hosts") {
            steps {
                sh """ssh-keyscan ${buidingVM} > ~/.ssh/known_hosts"""
                sh """ssh-keyscan ${prodVM} >> ~/.ssh/known_hosts"""
            }
        }    
        stage('Config buidingVM and prodVM') {
            steps {
                sh 'ansible-playbook playbook.yml -i hostsAnsible'
            }
        }
        stage("Preparering dockers images and push to dockerhub") {
            steps {
                sh """scp Dockerfile ${buidingVM}:/tmp"""              
                sh """ssh ${buidingVM} << EOF
		cd /tmp
                sudo docker build -t mywebbapp935ddd .
                docker image tag mywebbapp935ddd serp51/mywebbapp935ddd
                echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                docker push serp51/mywebbapp935ddd
                docker logout
EOF""" 
            }
        }
        stage('Pull and run docker app on prod server') {
            steps {
                sh """ssh ${prodVM} << EOF
                docker pull serp51/mywebbapp935ddd
                docker run -d -p 80:8080 serp51/mywebbapp935ddd
EOF"""
                sh """echo Result is here http://${prodVM}/hello-1.0/"""
            }
        }
    }

}
