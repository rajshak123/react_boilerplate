// def slackChannelName = '#api-ops'

def notifyBuild(String channelName, String buildStatus = 'STARTED') {
  // build status of null means successful
  // buildStatus =  buildStatus ?: 'SUCCESSFUL'

  // // Default values
  // def subject_full = "${buildStatus}: Job <${env.BUILD_URL}/console|${env.JOB_NAME} [${env.BUILD_NUMBER}]>"
  // def colorName = 'good'
  // project_key = 'com.trustingsocial.digitaljourney.dj-web-handler-frontend'

  // // Override default values based on build status
  // switch (buildStatus) {
  //   case ["STARTED"]:
  //     summary = subject_full.replaceAll("/console", "")
  //     break
  //   case ["SUCCESSFUL"]:
  //     summary = subject_full.replaceAll("/console", "")
  //     coverage_rate = sh(script: "curl -s -u $sonarToken: '$sonarHost/api/badges/measure?key=${project_key}&metric=coverage' | sed -e 's/<[^>]*>//g;s/%/ /g' | cut -d ' ' -f2", returnStdout: true).trim()
  //     summary = subject_full.replaceAll("/console", "") + "\n *DIGITAL-JOURNEY* - *PASSED* - _Code coverage *<${sonarHost}/dashboard?id=${project_key}|${coverage_rate}>*_ :tada:"
  //     break
  //   default:
  //     colorName = 'danger'
  //     summary = subject_full
  // }

  // // Send notifications
  // slackSend (channel: channelName, failOnError: true, color: colorName, message: summary)
}

def checkServer(String deployServer, String appPort, String credentials) {
  timeout(time: 30, unit: 'SECONDS') {
    waitUntil {
      def r = sshagent (credentials: [credentials]) {
                sh script: "ssh -oStrictHostKeyChecking=no -tt hopper@149.129.223.166 curl -s -o /dev/null -w '%{http_code}' 'http://${deployServer}:${appPort}' | grep 200", returnStatus: true      
              }
      echo "Result $r"
      sleep 10
      return (r == 0);
    }
  }
}


//Set discard job
properties([[$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', artifactDaysToKeepStr: '7', artifactNumToKeepStr: '10', daysToKeepStr: '7', numToKeepStr: '10']]]);

def buildImage(String imageTag, String dockerImage, String environment) {
  // return stage("Build docker image and push to registry for ${environment}") {
  //         docker.withRegistry('https://docker-registry.trustingsocial.com', "5f667fde-2dee-4686-97ba-f4c77ae47435") {
  //           def customImage = docker.build("${imageTag}", "-f ./ci/Dockerfile .")
  //           try {
  //             /* Push the container to the custom Registry */
  //             customImage.push()
  //           } catch (err) {
  //             throw err
  //           } finally {
  //               sh "docker rmi -f ${imageTag} ${dockerImage}"
  //           }
  //         }
  //     }
}

node {
  // def project = 'digital_journey'
  // def appName = 'dj-web-handler-frontend'
  // def appPort = '8010'
  // def conPort = '3000'
  // def privateRegistry = 'docker-registry.trustingsocial.com'
  // def imageTag = "${project}/${appName}:${env.BRANCH_NAME}.${env.BUILD_TIMESTAMP}"
  // def dockerImage = "${privateRegistry}/${imageTag}"
  try {
    sh("echo env.BRANCH_NAME")
    sh("echo ${env.BRANCH_NAME}")
    stage('Checkout source code') {
        checkout scm
    }
    if (env.BRANCH_NAME.matches("master|release-.*")) {
      sh("echo on-master")
      // notifyBuild(slackChannelName, 'STARTED')
    }
    stage('Install packages') {
      sh("docker run --rm -v `pwd`:/app -w /app node yarn install")
      // sh("sudo chown -R jenkins: ./node_modules")
    }

    stage('Set the enviroment variables') {
      sh("echo set-env-variables")
 
      // def deployServer = "103.89.1.215"
      // def credentials = "dj-frontend-deploy"

      // try {
      //   def VAULT_TOKEN = "1bcdf231-e30d-8f29-e4c6-e632b27b8933"
      //   sshagent (credentials: [credentials]) {
      //    jq is used the format the output and apply styling and -r helps in parsing it as an array
      //    sh "curl -H 'Content-Type: application/json' -H 'X-Vault-Token: ${VAULT_TOKEN}' https://vault-api.trustingsocial.com/v1/digital_journey/${appName}/testing  | jq -r '.data | to_entries | .[] | .key + \"=\" + .value' | sudo tee `pwd`/env/properties.env > /dev/null"
      //   }
      // }
      // catch (err) {
      //   throw err
      // } finally {
      // }
    }

    stage('Build static assets') {
      // sh("docker run --rm -v `pwd`:/app -w /app ls")
      sh("docker run --user='jenkins' --rm -v `pwd`:/app -w /app node yarn build")
      // def image = docker.image('node:11-alpine')
      //               image.pull()
      //               image.inside() {
      //                   sh 'id'
      //                   sh 'ls -lrt'
      //                   sh 'yarn install'u
      //                   sh 'yarn build'
      //               }
      // sh(script:"docker run -v `pwd`:/app -w /app  node yarn build")
      // sh(script:"docker run --rm --env-file `pwd`/env/properties.env -v `pwd`:/app -w /app node yarn test --silent", returnStatus: true)
    }

    stage('Run tests') {
      parallel(
        'Unit Tests': {
            try {
              def TEST_EXIT_CODE = sh(script:"docker run --rm --env-file `pwd`/env/properties.env -v `pwd`:/app -w /app node yarn test --silent", returnStatus: true)
              println TEST_EXIT_CODE
              assert TEST_EXIT_CODE == 0
            } catch (AssertionError e) {
                throw e
            }        
        }
      )
    }

    // stage "SonarQube analysis"
    // try {
    //   switch (env.BRANCH_NAME) {
    //     case ~/^(release-.*)|master/:
    //       sh(script:"docker run --rm --env-file `pwd`/env/properties.env -v `pwd`:/app -w /app node yarn test:coverage --silent", returnStatus: true)
    //       def scannerHome = tool 'SonarQube Scanner';
    //       withSonarQubeEnv {
    //         sh(script:"docker run --rm -v `pwd`:/app docker-registry.trustingsocial.com/devops/sonar-scanner -Dsonar.login='${SONAR_AUTH_TOKEN}' -Dsonar.host.url='${SONAR_HOST_URL}'", returnStatus: true)
    //         sonarToken = "${SONAR_AUTH_TOKEN}"
    //         sonarHost = "${SONAR_HOST_URL}"
    //       }
    //       break
    //     default:
    //       echo "no environment defined"
    //   }
    // } catch (e) {
    //   currentBuild.result = "FAILED"
    //   throw e
    // } finally {
    //   sh("rm -rf ./test-report.xml")
    // }

    switch (env.BRANCH_NAME) {
      case ~/^master/:
        stage("Build Webapp") {
          sh("docker run --rm -v `pwd`:/app -w /app node yarn build")
        }
        buildImage(imageTag, dockerImage, "Testing")
        break
      case ~/^staging/:
        stage("Build Webapp") {
          sh("docker run --rm -v `pwd`:/app -w /app node yarn build")
        }
        buildImage(imageTag, dockerImage, "Staging")
        break
      case ~/^(release-.*)/:
        stage("Build Webapp") {
          sh("docker run --rm -v `pwd`:/app -w /app node yarn build")
        }
        buildImage(imageTag, dockerImage, "Staging")
        break
      case 'release':
        stage("Build Webapp") {
          sh("docker run --rm -v `pwd`:/app -w /app node yarn build")
        }
        buildImage(imageTag, dockerImage, "Production")
        break
    }
  } catch (AssertionError e) {
    // If there was an exception thrown, the build failed
    currentBuild.result = "FAILED"
    throw e
  } catch (e) {
    currentBuild.result = "FAILED"
    throw e
  } finally {
    // Success or failure, always send notifications
    if (env.BRANCH_NAME.matches("master|release-.*")) {
      sh("echo notify-the-slack-channel")
      // notifyBuild(slackChannelName, currentBuild.result)
    }
  }

  try {  
    switch (env.BRANCH_NAME) {
      case ~/^master/:
        stage('Deploy to Testing Server') {
          sh("echo deploy-to-testing-server")

        // def VAULT_TOKEN = "1bcdf231-e30d-8f29-e4c6-e632b27b8933"
        // def credentials = "dj-service-deploy"
        // def deployServer = "172.19.0.16"
        // try {
        //   sshagent (credentials: [credentials]) {
        //     sh ("ssh -oStrictHostKeyChecking=no -tt hopper@149.129.223.166 ssh -tt root@${deployServer} 'sudo mkdir -p /etc/api/config/${appName}/'")
        //     sh ("ssh -oStrictHostKeyChecking=no -tt hopper@149.129.223.166 ssh -tt root@${deployServer} 'sh build/vault_init.sh ${VAULT_TOKEN} ${appName}'")
        //     sh ("ssh -oStrictHostKeyChecking=no -tt hopper@149.129.223.166 ssh -tt root@${deployServer} 'sh build/docker.sh  ${dockerImage} ${appName} ${appPort} ${conPort}'")
        //   }
        //   checkServer(deployServer, appPort,credentials)
        //   def summary = "DEPLOYED TO ${deployServer}:${appPort} Job <${env.BUILD_URL}|${env.JOB_NAME} [${env.BUILD_NUMBER}]>"
        //   slackSend (channel: slackChannelName, failOnError: true, color: 'good', message: summary)
        //   } catch (err) {
        //     throw err
        //   } finally {
        //     sshagent (credentials: [credentials]) {
        //       sh ("ssh -oStrictHostKeyChecking=no -tt hopper@149.129.223.166 ssh root@${deployServer} -tt 'docker logs ${appName};'")
        //     }
        //   }
        }
        break
      case ~/^(release-.*)/:
        stage('Deploy and activate application to staging environment') {
          //TODO (D.Vu): Write script to deploy to staging
        }
        break
      case 'release':
        stage('Deploy and activate application to production environment') {
          //TODO (D.Vu): Write script to deploy to production
        }
        break
    }
  } catch (err) {
    throw err
    def summary = "DEPLOY FAILED: Job <${env.BUILD_URL}/console|${env.JOB_NAME} [${env.BUILD_NUMBER}]>"
    slackSend (channel: slackChannelName, failOnError: true, color: 'danger', message: summary)
  }
}
