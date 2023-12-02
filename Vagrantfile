# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
  end

  config.vm.provision "shell", inline: <<-SHELL
echo "Sailor installer: Ubuntu 22.04"

apt-get update
apt-get install -y bc wget \
   curl \
   software-properties-common \
   cron \
   build-essential \
   certbot \
   git \
   incron \
   libjpeg-dev \
   libxml2-dev \
   libxslt1-dev \
   zlib1g-dev \
   nginx-full \
   python3 \
   python3-certbot-nginx \
   python3-dev \
   python3-pip \
   python3-click \
   python3-virtualenv \
   python3-yaml \
   uwsgi \
   uwsgi-plugin-asyncio-python3 \
   uwsgi-plugin-gevent-python3 \
   uwsgi-plugin-python3 \
   uwsgi-plugin-tornado-python3 \
   php-fpm \
   nodejs \
   npm \
   nodeenv
add-apt-repository ppa:deadsnakes/ppa -y
apt install python3.11 -y

PAAS_USERNAME=sailor

# Create user
adduser --disabled-password --gecos 'PaaS access' --ingroup www-data $PAAS_USERNAME

# install sailor
su - $PAAS_USERNAME -c "wget https://raw.githubusercontent.com/mardix/sailor/master/sailor.py && python3 ~/sailor.py init"

ln /home/$PAAS_USERNAME/.sailor/uwsgi/uwsgi.ini /etc/uwsgi/apps-enabled/sailor.ini
systemctl restart uwsgi

wget --quiet https://raw.githubusercontent.com/mardix/sailor/master/nginx.conf -O /etc/nginx/sites-available/default
wget --quiet https://raw.githubusercontent.com/mardix/sailor/master/incron.conf -O /var/www/html/index.sailor.html
wget --quiet https://raw.githubusercontent.com/mardix/sailor/master/index.sailor.html -O /etc/incron.d/sailor

echo ""
echo "Sailor installation complete!"
echo ""
echo "Execute the following command to configure the new VM as 'sailor' SSH host:"
echo ""
echo "    vagrant ssh-config | grep -v IdentityFile | sed 's/User vagrant/User sailor/' | sed 's/Host default/Host sailor/' >> ~/.ssh/config"
echo ""
echo "Add current user's public SSH key to sailor authorized keys:"
echo ""
echo "    ssh-keygen -y -f ~/.ssh/id_rsa | vagrant ssh -c 'sudo -u sailor python3 ~sailor/sailor.py x:set-ssh -'"
SHELL

end
