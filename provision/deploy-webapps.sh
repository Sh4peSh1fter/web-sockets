echo "*************************************************************************"
echo "Generate self-signed certificates"
echo "*************************************************************************"

mkdir -p /home/vagrant/apps/certs
sudo chown vagrant:vagrant /home/vagrant/apps/certs
openssl req -x509 -newkey rsa:4096 -keyout /home/vagrant/apps/certs/server.key -out /home/vagrant/apps/certs/server.crt -days 365 -nodes -subj "/C=US/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"

echo "*************************************************************************"
echo "docker compose deploy apps"
echo "*************************************************************************"

sudo su - vagrant -c "docker compose -f /home/vagrant/apps/docker-compose.yaml up -d --build"