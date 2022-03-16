
echo "Sailor installer"

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
   python-yaml \
   uwsgi \
   uwsgi-plugin-asyncio-python3 \
   uwsgi-plugin-gevent-python3 \
   uwsgi-plugin-python3 \
   uwsgi-plugin-tornado-python3 \
   php-fpm \
   nodejs \
   npm \
   nodeenv
apt-get update

PAAS_USERNAME=sailor

# Create user
sudo adduser --disabled-password --gecos 'PaaS access' --ingroup www-data $PAAS_USERNAME

# copy your public key to /tmp (assuming it's the first entry in authorized_keys)
head -1 ~/.ssh/authorized_keys > /tmp/pubkey
# install sailor and have it set up SSH keys and default files
sudo su - $PAAS_USERNAME -c "wget https://raw.githubusercontent.com/mardix/sailor/master/sailor.py && python3 ~/sailor.py init && python3 ~/sailor.py system:set-ssh /tmp/pubkey"
rm /tmp/pubkey


sudo ln /home/$PAAS_USERNAME/.sailor/uwsgi/uwsgi.ini /etc/uwsgi/apps-enabled/sailor.ini
sudo systemctl restart uwsgi

cd /tmp
wget https://raw.githubusercontent.com/mardix/sailor/master/incron.conf
wget https://raw.githubusercontent.com/mardix/sailor/master/nginx.conf
wget https://raw.githubusercontent.com/mardix/sailor/master/index.sailor.html
cp /tmp/nginx.conf /etc/nginx/sites-available/default
cp /tmp/incron.conf /etc/incron.d/sailor
cp /tmp/index.sailor.html /var/www/html

echo ""
echo "Sailor installation complete!"