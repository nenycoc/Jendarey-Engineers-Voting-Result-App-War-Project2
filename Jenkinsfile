pipeline{
    agent any

    tools {
        maven 'MAVEN3'
        git 'Default'
        jdk 'OracleJDK17'
        }

    stages {
        stage('1-Fetch the Code') {
            steps {
                echo 'Cloning the latest application version from GitHub'
                checkout scmGit(branches: [[name: '*/feature-bug-fix']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/JendareyTechnologies/Jendarey-Engineers-Voting-Result-App-War-Project2.git']])
                
            }
        }

        stage('2-Build the Code') {
            steps {
                echo 'Cleaning and building packages'
                sh 'mvn clean install -DskipTests=true'
                
            }
        }

        stage('3-Unit Test') {
            steps {
                echo 'Jenkins is running JUnit-test-cases'
                sh 'mvn test'
                
            }
        }

        stage('4-OWASP Scan') {
            steps {
                echo 'Jenkins is setting up Owasp-Scan'
                echo 'Jenkins is performing Owasp-Scan Analysis'
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'Jendarey-Dependency-Check'
                
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
                sh 'mvn deploy'
                echo 'Jenkins uploaded Artifacts to Nexus'

            }
        }

        stage('7-Deploy to Tomcat') {
            steps {
                echo 'Jenkins is about to deploy our application to Production environment'
                deploy adapters: [tomcat9(credentialsId: 'tomcatnewpassword', path: '', url: 'http://100.26.162.90:8080/')], contextPath: null, onFailure: false, war: 'target/*.war'

            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded! Sending final notification...'
            slackSend(
                channel: '#classa23-jenkins-project-pipeline',
                color: 'good',
                message: "*SUCCESS:* Job '${env.JOB_NAME}' build ${env.BUILD_NUMBER} has succeeded. \n Please check for more information at: ${env.BUILD_URL}"
            )
        }
        failure {
            echo 'Pipeline failed! Sending final notification...'
            slackSend(
                channel: '#classa23-jenkins-project-pipeline',
                color: 'danger',
                message: "*FAILURE:* Job '${env.JOB_NAME}' build ${env.BUILD_NUMBER} has failed. \n Please check for more information at: ${env.BUILD_URL}"
            )
        }
    }
}
