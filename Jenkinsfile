  pipeline{
    agent any

    tools {
        jdk 'OracleJDK17'
        maven 'MAVEN3'
        git 'Default'
        }
    
    stages {
        stage('1-Fetch the Code') {
            steps {
                echo 'Cloning the latest application version from GitHub'
                git 'https://github.com/JendareyTechnologies/Jendarey-Engineers-Voting-Result-App-War-Project2.git'
                
            }
         }

        stage('2-Build the Code') {
            steps {
                echo 'Cleaning and building packages'
                sh 'mvn clean install -DskipTests'
                
            }
        }

        stage('3-Unit Test') {
            steps {
                echo 'Jenkins is running JUnit-test-cases'
                sh 'mvn test'
                
            }
        }

        stage('4-OWASP-Scan') {
            steps {
                echo 'Jenkins is setting up Owasp-Scan'
                echo 'Jenkins is performing Owasp-Scan Analysis'
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'Dependency-Check'
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

        stage('7-Deploy to UAT') {
            steps {
                echo 'Jenkins is about to deploy our application to User Acceptance Testing environment'
                deploy adapters: [tomcat9(credentialsId: 'Jenkins-Tomcat-Cred', path: '', url: 'http://100.26.162.90:8080/')], contextPath: null, war: 'target/*.war'
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
                echo 'Jenkins is about to deploy our application to Production environment'
                deploy adapters: [tomcat9(credentialsId: 'Jenkins-Tomcat-Cred', path: '', url: 'http://100.26.162.90:8080/')], contextPath: null, war: 'target/*.war'
            }
        }

    }
    
}

