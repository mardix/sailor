
echo "Polybox installer (Ubuntu-18.04LTS)"

apt-get update
apt-get install -y wget curl cron build-essential certbot git incron \
   libjpeg-dev libxml2-dev libxslt1-dev zlib1g-dev nginx \
   python-certbot-nginx python-dev python-pip python-virtualenv \
   python3-dev python3-pip python3-click python3-virtualenv \
   uwsgi uwsgi-plugin-asyncio-python3 uwsgi-plugin-gevent-python \
   uwsgi-plugin-python uwsgi-plugin-python3 uwsgi-plugin-tornado-python\
   python-yaml php-fpm nodejs npm nodeenv
apt-get update

PAAS_USERNAME=polybox

# Create user
sudo adduser --disabled-password --gecos 'PaaS access' --ingroup www-data $PAAS_USERNAME

# copy your public key to /tmp (assuming it's the first entry in authorized_keys)
head -1 ~/.ssh/authorized_keys > /tmp/pubkey
# install polybox and have it set up SSH keys and default files
sudo su - $PAAS_USERNAME -c "wget https://raw.githubusercontent.com/mardix/polybox/master/polybox.py && python3 ~/polybox.py init && python3 ~/polybox.py set-ssh /tmp/pubkey"
rm /tmp/pubkey


sudo ln /home/$PAAS_USERNAME/.polybox/uwsgi/uwsgi.ini /etc/uwsgi/apps-enabled/polybox.ini
sudo systemctl restart uwsgi

cd /tmp
wget https://raw.githubusercontent.com/mardix/polybox/master/incron.conf
wget https://raw.githubusercontent.com/mardix/polybox/master/nginx.conf
cp /tmp/nginx.conf /etc/nginx/sites-available/default
cp /tmp/incron.conf /etc/incron.d/polybox

echo ""
echo "Polybox installation complete!"