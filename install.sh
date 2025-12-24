#!/bin/bash

# Script instalasi lengkap Development Environment di Ubuntu 22.04
# Jalankan dengan: sudo bash script.sh

set -e

echo "=== Memulai instalasi Development Environment ==="

# Update system
echo "1. Update system..."
apt update && apt upgrade -y

# Install dependencies
echo "2. Install dependencies..."
apt install -y wget curl gpg software-properties-common apt-transport-https ca-certificates lsb-release gnupg2

# Install Google Chrome
echo "3. Install Google Chrome..."
wget -q -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y /tmp/google-chrome-stable_current_amd64.deb
rm /tmp/google-chrome-stable_current_amd64.deb

# Install Microsoft Edge
echo "4. Install Microsoft Edge..."
wget -q -O /tmp/microsoft-edge-stable_current_amd64.deb https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-stable/microsoft-edge-stable_131.0.2903.112-1_amd64.deb
apt install -y /tmp/microsoft-edge-stable_current_amd64.deb || {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list
    apt update
    apt install -y microsoft-edge-stable
}
rm -f /tmp/microsoft-edge-stable_current_amd64.deb

# Install VS Code
echo "5. Install Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/packages.microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
apt update
apt install -y code

# Install Sublime Text
echo "6. Install Sublime Text..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
echo "deb https://download.sublimetext.com/ apt/stable/" > /etc/apt/sources.list.d/sublime-text.list
apt update
apt install -y sublime-text

# Install Nginx 1.29 (mainline)
echo "7. Install Nginx 1.29..."
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list
apt update
apt install -y nginx

# Konfigurasi Nginx
echo "   - Configuring Nginx..."

# Ganti user nginx menjadi www-data di nginx.conf
sed -i 's/^user  nginx;/user  www-data;/' /etc/nginx/nginx.conf

# Backup default.conf original
cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.backup

# Buat default.conf baru dengan konfigurasi PHP-FPM
cat > /etc/nginx/conf.d/default.conf << 'EOF'
server {
    listen       80;
    server_name  localhost;
    #access_log  /var/log/nginx/host.access.log  main;
    location / {
        root /usr/share/nginx/html;
        index index.php index.html index.htm;
        try_files $uri $uri/ /index.php?$args;
    }
    #error_page  404              /404.html;
    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}
    location ~ \.php$ {
    # root html;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /usr/share/nginx/html$fastcgi_script_name;
        include fastcgi_params;
    }
    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}
EOF

# Test konfigurasi nginx
nginx -t

# Start dan enable nginx
systemctl start nginx
systemctl enable nginx

echo "   ✓ Nginx configured with www-data user and PHP 7.4-FPM"

# Install Multiple PHP Versions dengan package lengkap
echo "8. Install Multiple PHP Versions..."
add-apt-repository -y ppa:ondrej/php
apt update

# Install PHP 7.4-FPM dengan package lengkap
echo "   - Installing PHP 7.4-FPM..."
apt install -y php7.4-fpm php7.4-cli php7.4-common php7.4-mysql php7.4-zip php7.4-curl php7.4-gd php7.4-mbstring php7.4-xml php7.4-bcmath php7.4-phpdbg php7.4-cgi libphp7.4-embed openssl php7.4-xmlrpc php7.4-imagick php7.4-dev php7.4-imap php7.4-soap php7.4-json php7.4-opcache php7.4-redis php7.4-intl php7.4-bz2 php7.4-calendar php7.4-ctype php7.4-dba php7.4-dom php7.4-enchant php7.4-exif php7.4-fileinfo php7.4-ftp php7.4-gettext php7.4-gmp php7.4-iconv php7.4-mysqli php7.4-odbc php7.4-pdo php7.4-pdo-mysql php7.4-pdo-odbc php7.4-pdo-sqlite php7.4-phar php7.4-posix php7.4-pspell php7.4-simplexml php7.4-snmp php7.4-sockets php7.4-sqlite3 php7.4-tidy php7.4-xmlreader php7.4-xmlwriter php7.4-xsl php7.4-mysqlnd php7.4-memcache php7.4-memcached php7.4-xdebug

# Install PHP 8.0-FPM dengan package lengkap
echo "   - Installing PHP 8.0-FPM..."
apt install -y php8.0-fpm php8.0-cli php8.0-common php8.0-mysql php8.0-zip php8.0-curl php8.0-gd php8.0-mbstring php8.0-xml php8.0-bcmath php8.0-phpdbg php8.0-cgi libphp8.0-embed openssl php8.0-xmlrpc php8.0-imagick php8.0-dev php8.0-imap php8.0-soap php8.0-opcache php8.0-redis php8.0-intl php8.0-bz2 php8.0-calendar php8.0-ctype php8.0-dba php8.0-dom php8.0-enchant php8.0-exif php8.0-fileinfo php8.0-ftp php8.0-gettext php8.0-gmp php8.0-iconv php8.0-mysqli php8.0-odbc php8.0-pdo php8.0-pdo-mysql php8.0-pdo-odbc php8.0-pdo-sqlite php8.0-phar php8.0-posix php8.0-pspell php8.0-simplexml php8.0-snmp php8.0-sockets php8.0-sqlite3 php8.0-tidy php8.0-xmlreader php8.0-xmlwriter php8.0-xsl php8.0-mysqlnd php8.0-memcache php8.0-memcached php8.0-xdebug

# Install PHP 8.1-FPM dengan package lengkap
echo "   - Installing PHP 8.1-FPM..."
apt install -y php8.1-fpm php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-curl php8.1-gd php8.1-mbstring php8.1-xml php8.1-bcmath php8.1-phpdbg php8.1-cgi libphp8.1-embed openssl php8.1-xmlrpc php8.1-imagick php8.1-dev php8.1-imap php8.1-soap php8.1-opcache php8.1-redis php8.1-intl php8.1-bz2 php8.1-calendar php8.1-ctype php8.1-dba php8.1-dom php8.1-enchant php8.1-exif php8.1-fileinfo php8.1-ftp php8.1-gettext php8.1-gmp php8.1-iconv php8.1-mysqli php8.1-odbc php8.1-pdo php8.1-pdo-mysql php8.1-pdo-odbc php8.1-pdo-sqlite php8.1-phar php8.1-posix php8.1-pspell php8.1-simplexml php8.1-snmp php8.1-sockets php8.1-sqlite3 php8.1-tidy php8.1-xmlreader php8.1-xmlwriter php8.1-xsl php8.1-mysqlnd php8.1-memcache php8.1-memcached php8.1-xdebug

# Install PHP 8.2-FPM dengan package lengkap
echo "   - Installing PHP 8.2-FPM..."
apt install -y php8.2-fpm php8.2-cli php8.2-common php8.2-mysql php8.2-zip php8.2-curl php8.2-gd php8.2-mbstring php8.2-xml php8.2-bcmath php8.2-phpdbg php8.2-cgi libphp8.2-embed openssl php8.2-xmlrpc php8.2-imagick php8.2-dev php8.2-imap php8.2-soap php8.2-opcache php8.2-redis php8.2-intl php8.2-bz2 php8.2-calendar php8.2-ctype php8.2-dba php8.2-dom php8.2-enchant php8.2-exif php8.2-fileinfo php8.2-ftp php8.2-gettext php8.2-gmp php8.2-iconv php8.2-mysqli php8.2-odbc php8.2-pdo php8.2-pdo-mysql php8.2-pdo-odbc php8.2-pdo-sqlite php8.2-phar php8.2-posix php8.2-pspell php8.2-simplexml php8.2-snmp php8.2-sockets php8.2-sqlite3 php8.2-tidy php8.2-xmlreader php8.2-xmlwriter php8.2-xsl php8.2-mysqlnd php8.2-memcache php8.2-memcached php8.2-xdebug

# Install PHP 8.3-FPM dengan package lengkap
echo "   - Installing PHP 8.3-FPM..."
apt install -y php8.3-fpm php8.3-cli php8.3-common php8.3-mysql php8.3-zip php8.3-curl php8.3-gd php8.3-mbstring php8.3-xml php8.3-bcmath php8.3-phpdbg php8.3-cgi libphp8.3-embed openssl php8.3-xmlrpc php8.3-imagick php8.3-dev php8.3-imap php8.3-soap php8.3-opcache php8.3-redis php8.3-intl php8.3-bz2 php8.3-calendar php8.3-ctype php8.3-dba php8.3-dom php8.3-enchant php8.3-exif php8.3-fileinfo php8.3-ftp php8.3-gettext php8.3-gmp php8.3-iconv php8.3-mysqli php8.3-odbc php8.3-pdo php8.3-pdo-mysql php8.3-pdo-odbc php8.3-pdo-sqlite php8.3-phar php8.3-posix php8.3-pspell php8.3-simplexml php8.3-snmp php8.3-sockets php8.3-sqlite3 php8.3-tidy php8.3-xmlreader php8.3-xmlwriter php8.3-xsl php8.3-mysqlnd php8.3-memcache php8.3-memcached php8.3-xdebug

# Start and enable PHP-FPM services
echo "   - Starting PHP-FPM services..."
systemctl start php7.4-fpm php8.0-fpm php8.1-fpm php8.2-fpm php8.3-fpm
systemctl enable php7.4-fpm php8.0-fpm php8.1-fpm php8.2-fpm php8.3-fpm

# Install Composer
echo "9. Install Composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js 22
echo "10. Install Node.js 22..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
npm install -g npm@latest

# Install PM2
echo "   - Installing PM2..."
npm install -g pm2
pm2 startup systemd -u root --hp /root
pm2 save


# Install MariaDB (latest stable)
echo "12. Install MariaDB..."
curl -fsSL https://r.mariadb.com/downloads/mariadb_repo_setup | bash -s -- --mariadb-server-version="mariadb-11.4"
apt update
apt install -y mariadb-server mariadb-client
systemctl start mariadb
systemctl enable mariadb

echo ""
echo "   ⚠️  PENTING: Jalankan mysql_secure_installation setelah script selesai!"
echo "   Command: sudo mysql_secure_installation"
echo ""

# Install phpMyAdmin
echo "13. Install phpMyAdmin..."
PHPMYADMIN_VERSION=$(curl -s https://www.phpmyadmin.net/downloads/ | grep -oP 'phpMyAdmin-\K[0-9]+\.[0-9]+\.[0-9]+' | head -1)
cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz
tar xzf phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.tar.gz
mkdir -p /usr/share/phpmyadmin
mv phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages/* /usr/share/phpmyadmin/
rm -rf phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages*

# Setup phpMyAdmin config
cp /usr/share/phpmyadmin/config.sample.inc.php /usr/share/phpmyadmin/config.inc.php
sed -i "s/\$cfg\['blowfish_secret'\] = '';/\$cfg['blowfish_secret'] = '$(openssl rand -base64 32)';/" /usr/share/phpmyadmin/config.inc.php

# Create symbolic link to nginx html
mkdir -p /usr/share/nginx/html
ln -sf /usr/share/phpmyadmin /usr/share/nginx/html/dbmyadmin

# Set permissions
chown -R www-data:www-data /usr/share/phpmyadmin
chmod -R 755 /usr/share/phpmyadmin

# Install Certbot
echo "14. Install Certbot..."
apt install -y certbot python3-certbot-nginx

echo ""
echo "=== Instalasi Selesai ==="
echo ""
echo "========================================"
echo "APLIKASI YANG TERINSTAL:"
echo "========================================"
echo "Browsers:"
echo "  - Google Chrome: $(google-chrome --version 2>/dev/null || echo 'Terinstal')"
echo "  - Microsoft Edge: $(microsoft-edge --version 2>/dev/null || echo 'Terinstal')"
echo ""
echo "Editors:"
echo "  - VS Code: $(code --version 2>/dev/null | head -n 1 || echo 'Terinstal')"
echo "  - Sublime Text: $(subl --version 2>/dev/null || echo 'Terinstal')"
echo ""
echo "Web Server:"
echo "  - Nginx: $(nginx -v 2>&1 | grep -oP 'nginx/\K.*')"
echo ""
echo "PHP Versions:"
php7.4 -v 2>/dev/null | head -n 1
php8.0 -v 2>/dev/null | head -n 1
php8.1 -v 2>/dev/null | head -n 1
php8.2 -v 2>/dev/null | head -n 1
php8.3 -v 2>/dev/null | head -n 1
echo ""
echo "PHP-FPM Services Status:"
systemctl is-active php7.4-fpm --quiet && echo "  ✓ PHP 7.4-FPM: Running" || echo "  ✗ PHP 7.4-FPM: Stopped"
systemctl is-active php8.0-fpm --quiet && echo "  ✓ PHP 8.0-FPM: Running" || echo "  ✗ PHP 8.0-FPM: Stopped"
systemctl is-active php8.1-fpm --quiet && echo "  ✓ PHP 8.1-FPM: Running" || echo "  ✗ PHP 8.1-FPM: Stopped"
systemctl is-active php8.2-fpm --quiet && echo "  ✓ PHP 8.2-FPM: Running" || echo "  ✗ PHP 8.2-FPM: Stopped"
systemctl is-active php8.3-fpm --quiet && echo "  ✓ PHP 8.3-FPM: Running" || echo "  ✗ PHP 8.3-FPM: Stopped"
echo ""
echo "JavaScript Runtimes:"
echo "  - Node.js: $(node -v 2>/dev/null || echo 'Terinstal')"
echo "  - NPM: $(npm -v 2>/dev/null || echo 'Terinstal')"
echo "  - PM2: $(pm2 -v 2>/dev/null || echo 'Terinstal')"
echo ""
echo "Database:"
echo "  - MariaDB: $(mysql --version 2>/dev/null | grep -oP 'Distrib \K[^,]+')"
echo "  - phpMyAdmin: ${PHPMYADMIN_VERSION} → http://YOUR_IP/dbmyadmin"
echo ""
echo "Tools:"
echo "  - Composer: $(composer --version 2>/dev/null | grep -oP 'Composer version \K[^ ]+')"
echo "  - PM2: $(pm2 -v 2>/dev/null || echo 'Terinstal')"
echo "  - Certbot: $(certbot --version 2>&1 | grep -oP 'certbot \K.*')"
echo ""
echo "========================================"
echo "KONFIGURASI:"
echo "========================================"
echo ""
echo "PHP-FPM Socket Locations:"
echo "  - PHP 7.4: /run/php/php7.4-fpm.sock"
echo "  - PHP 8.0: /run/php/php8.0-fpm.sock"
echo "  - PHP 8.1: /run/php/php8.1-fpm.sock"
echo "  - PHP 8.2: /run/php/php8.2-fpm.sock"
echo "  - PHP 8.3: /run/php/php8.3-fpm.sock"
echo ""
echo "Nginx Config: /etc/nginx/nginx.conf"
echo "  - User: www-data ✓"
echo "Nginx Sites: /etc/nginx/conf.d/"
echo "  - default.conf: Configured with PHP 7.4-FPM ✓"
echo "  - Backup: /etc/nginx/conf.d/default.conf.backup"
echo ""
echo "phpMyAdmin:"
echo "  - Location: /usr/share/phpmyadmin"
echo "  - Symlink: /usr/share/nginx/html/dbmyadmin"
echo "  - URL: http://YOUR_SERVER_IP/dbmyadmin"
echo ""
echo "========================================"
echo "LANGKAH SELANJUTNYA:"
echo "========================================"
echo ""
echo "1. Secure MariaDB:"
echo "   sudo mysql_secure_installation"
echo ""
echo "2. Ganti PHP CLI default (optional):"
echo "   sudo update-alternatives --config php"
echo ""
echo "3. Test Nginx config:"
echo "   sudo nginx -t"
echo "   sudo systemctl reload nginx"
echo ""
echo "4. Ganti versi PHP di Nginx (edit /etc/nginx/conf.d/default.conf):"
echo "   Ubah: fastcgi_pass unix:/run/php/php7.4-fpm.sock;"
echo "   Ke: fastcgi_pass unix:/run/php/php8.3-fpm.sock;"
echo "   Lalu: sudo systemctl reload nginx"
echo ""
echo "5. Setup SSL dengan Certbot:"
echo "   sudo certbot --nginx -d yourdomain.com"
echo ""
echo "6. PM2 sudah auto-startup, untuk manage aplikasi:"
echo "   pm2 start app.js --name myapp"
echo "   pm2 list"
echo "   pm2 logs"
echo "   pm2 restart myapp"
echo "   pm2 stop myapp"
echo "   pm2 delete myapp"
echo ""
echo "========================================"
echo "Script selesai! Happy coding! 🚀"
echo "========================================"
