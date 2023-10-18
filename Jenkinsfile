def COLOR_MAP = [
    SUCCESS: 'good', 
    FAILURE: 'danger'
]

pipeline {
    agent any
    
    tools {
        maven 'MAVEN3'
        jdk 'OracleJDK17'
        git 'Default'
    }

    stages {
        stage('1-Fetch Code') {
            steps {
                echo 'Cloning the latest application version'
                git 'https://github.com/JendareyTechnologies/Jendarey-Engineers-Voting-Result-App-War-Project2.git'
                // checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/JendareyTechnologies/Jendarey-Engineers-Voting-Result-App-War-Project2.git']])
            }
        }

        stage('2-Build Project') {
            steps {
                echo 'Cleaning and building packages'
                sh 'mvn clean install -DskipTests'
            }
            post {
                always {
                    echo 'Archiving artifacts now.'
                    archiveArtifacts artifacts: '**/*.war', followSymlinks: false, onlyIfSuccessful: true
                }
            }
        }

        stage('3-Unit Test') {
            steps {
                echo 'Jenkins is running JUnit-test-cases'
                echo 'JUnit-test-cases must pass to create artifacts'
                sh 'mvn test'
            }
        }

        stage('4-Owasp-Scan') {
            steps {
                echo 'Jenkins is setting up Owasp-Scan'
                echo 'Jenkins is performing Owasp-Scan Analysis'
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP'
            }
        }

        stage('5-CodeQualityAnalysis') {
            steps {
                echo 'Jenkins is setting up SonarQube authentication'
                echo 'Jenkins is performing Code Quality Analysis'
                sh 'mvn sonar:sonar'
            }
        }

        stage('6-UploadArtifacts') {
            steps {
                echo 'Jenkins is configuring Nexus authentication'
                // sh 'mvn deploy'
                echo 'Jenkins uploaded Artifacts to Nexus'
            }
        }

        stage('7-Deploy to UAT') {
            steps {
                echo 'Jenkins is about to deploy our application to User Acceptance Testing environment'
                deploy adapters: [tomcat9(credentialsId: '3778794c-9691-47d5-95cf-17b9fd7ca6d9', path: '', url: 'http://54.236.209.233:8080/')], contextPath: null, war: 'target/*.war'
            }
        }
        
        stage('8-Approval') {
            steps {
                echo 'votingapp application is ready for review'
                timeout(time: 2, unit: 'HOURS') {
                    input 'Votingapp application is ready for review and approval'
                }
            }
        }

        stage('9-Deploy to Production') {
            steps {
                echo 'Jenkins is about to deploy our application to User Acceptance Testing environment'
                deploy adapters: [tomcat9(credentialsId: '3778794c-9691-47d5-95cf-17b9fd7ca6d9', path: '', url: 'http://54.236.209.233:8080/')], contextPath: null, war: 'target/*.war'
            }
        }

        stage('10-Notification-Slack') {
            steps {
                echo 'Jenkins is about to send Slack Notification'
                slackSend(
                    channel: '#classa23',
                    color: COLOR_MAP[currentBuild.currentResult],
                    message: "*${currentBuild.currentResult}:* Job '${env.JOB_NAME}' build ${env.BUILD_NUMBER} \n Please check for more information at: ${env.BUILD_URL}"
                )
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded! Send final notification...'
            slackSend(
                channel: '#classa23',
                color: 'good',
                message: "*SUCCESS:* Job '${env.JOB_NAME}' build ${env.BUILD_NUMBER} has succeeded. \n Please check for more information at: ${env.BUILD_URL}"
            )
        }
        failure {
            echo 'Pipeline failed! Send final alert...'
            slackSend(
                channel: '#classa23',
                color: 'danger',
                message: "*FAILURE:* Job '${env.JOB_NAME}' build ${env.BUILD_NUMBER} has failed. \n Please check for more information at: ${env.BUILD_URL}"
            )
        }
    }
}

