#!/bin/bash

echo "*************************************************************************"
echo "docker compose deploy infra"
echo "*************************************************************************"

sudo su - vagrant -c "docker compose -f /home/vagrant/infra/docker-compose.yaml up -d --build"

echo "*************************************************************************"
echo "Wait for Jenkins to start"
echo "*************************************************************************"

until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
    printf '.'
    sleep 5
done

echo "*************************************************************************"
echo "Install Jenkins CLI and plugins"
echo "*************************************************************************"

# Get the initial admin password
JENKINS_PASSWORD=$(docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword)

wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080 -auth admin:$JENKINS_PASSWORD install-plugin docker-workflow git workflow-aggregator configuration-as-code
java -jar jenkins-cli.jar -s http://localhost:8080 -auth admin:$JENKINS_PASSWORD safe-restart

echo "*************************************************************************"
echo "Wait for Jenkins to restart"
echo "*************************************************************************"

until $(curl --output /dev/null --silent --head --fail http://localhost:8080); do
    printf '.'
    sleep 5
done

echo "*************************************************************************"
echo "Jenkins is ready"
echo "*************************************************************************"
