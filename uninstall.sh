#!/bin/bash

# Script uninstall Development Environment di Ubuntu 22.04
# FORCE REMOVE - Langsung hapus tanpa konfirmasi
# Jalankan dengan: sudo bash uninstall.sh

set -e

echo "=========================================="
echo "FORCE UNINSTALL DEVELOPMENT ENVIRONMENT"
echo "=========================================="
echo ""
echo "🔥 Menghapus semua tanpa konfirmasi..."
echo ""

# Stop semua services terlebih dahulu
echo "1. Stopping all services..."
systemctl stop nginx 2>/dev/null || true
systemctl stop php7.4-fpm 2>/dev/null || true
systemctl stop php8.0-fpm 2>/dev/null || true
systemctl stop php8.1-fpm 2>/dev/null || true
systemctl stop php8.2-fpm 2>/dev/null || true
systemctl stop php8.3-fpm 2>/dev/null || true
systemctl stop mariadb 2>/dev/null || true
systemctl stop mysql 2>/dev/null || true
systemctl stop bind9 2>/dev/null || true
pm2 kill 2>/dev/null || true

# Uninstall Google Chrome
echo "2. Uninstalling Google Chrome..."
apt remove --purge -y google-chrome-stable 2>/dev/null || true

# Uninstall Microsoft Edge
echo "3. Uninstalling Microsoft Edge..."
apt remove --purge -y microsoft-edge-stable 2>/dev/null || true
rm -f /etc/apt/sources.list.d/microsoft-edge.list
rm -f /etc/apt/trusted.gpg.d/microsoft.gpg

# Uninstall VS Code
echo "4. Uninstalling VS Code..."
apt remove --purge -y code 2>/dev/null || true
rm -f /etc/apt/sources.list.d/vscode.list
rm -f /etc/apt/trusted.gpg.d/packages.microsoft.gpg

# Uninstall Sublime Text
echo "5. Uninstalling Sublime Text..."
apt remove --purge -y sublime-text 2>/dev/null || true
rm -f /etc/apt/sources.list.d/sublime-text.list
rm -f /etc/apt/trusted.gpg.d/sublimehq-archive.gpg

# Uninstall Nginx
echo "6. Uninstalling Nginx..."
apt remove --purge -y nginx nginx-common 2>/dev/null || true
rm -rf /etc/nginx
rm -rf /var/log/nginx
rm -rf /var/www/html
rm -f /etc/apt/sources.list.d/nginx.list
rm -f /usr/share/keyrings/nginx-archive-keyring.gpg

# Uninstall All PHP versions
echo "7. Uninstalling PHP versions..."

# PHP 7.4
apt remove --purge -y php7.4* libapache2-mod-php7.4 2>/dev/null || true

# PHP 8.0
apt remove --purge -y php8.0* libapache2-mod-php8.0 2>/dev/null || true

# PHP 8.1
apt remove --purge -y php8.1* libapache2-mod-php8.1 2>/dev/null || true

# PHP 8.2
apt remove --purge -y php8.2* libapache2-mod-php8.2 2>/dev/null || true

# PHP 8.3
apt remove --purge -y php8.3* libapache2-mod-php8.3 2>/dev/null || true

# Remove PHP common packages
apt remove --purge -y php-common php-pear 2>/dev/null || true

# Remove PHP repository
add-apt-repository --remove -y ppa:ondrej/php 2>/dev/null || true

# Clean PHP configs
rm -rf /etc/php

# Uninstall Composer
echo "8. Uninstalling Composer..."
rm -f /usr/local/bin/composer

# Uninstall Node.js and NPM
echo "9. Uninstalling Node.js, NPM, and PM2..."
npm uninstall -g pm2 2>/dev/null || true
apt remove --purge -y nodejs 2>/dev/null || true
rm -rf /usr/lib/node_modules
rm -rf /usr/local/lib/node_modules
rm -f /etc/apt/sources.list.d/nodesource.list
rm -f /usr/share/keyrings/nodesource.gpg

# Uninstall Bun
echo "10. Uninstalling Bun.js..."
rm -rf ~/.bun
rm -f /etc/profile.d/bun.sh
rm -rf /root/.bun

# Uninstall MariaDB
echo "11. Uninstalling MariaDB (including all databases)..."
systemctl stop mariadb 2>/dev/null || true
systemctl stop mysql 2>/dev/null || true
apt remove --purge -y mariadb-* mysql-* 2>/dev/null || true
rm -rf /etc/mysql
rm -rf /var/lib/mysql
rm -rf /var/log/mysql
rm -f /etc/apt/sources.list.d/mariadb.list
# Hapus user mysql jika ada
userdel mysql 2>/dev/null || true
groupdel mysql 2>/dev/null || true

# Uninstall phpMyAdmin
echo "12. Uninstalling phpMyAdmin..."
rm -rf /usr/share/phpmyadmin
rm -f /usr/share/nginx/html/dbmyadmin

# Uninstall Certbot
echo "13. Uninstalling Certbot..."
apt remove --purge -y certbot python3-certbot-nginx 2>/dev/null || true

# Uninstall Bind9
echo "14. Uninstalling Bind9..."
apt remove --purge -y bind9 bind9utils bind9-doc dnsutils 2>/dev/null || true
rm -rf /etc/bind

# Clean up
echo "15. Deep cleaning system..."
apt autoremove -y
apt autoclean
apt clean

# Hapus cache dan temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf ~/.cache/*
rm -rf ~/.npm
rm -rf ~/.composer

# Remove nginx user if exists
if id "nginx" &>/dev/null; then
    userdel nginx 2>/dev/null || true
    groupdel nginx 2>/dev/null || true
fi

# Update apt cache
apt update

echo ""
echo "=========================================="
echo "✅ UNINSTALL SELESAI - SISTEM BERSIH"
echo "=========================================="
echo ""
echo "✓ Semua aplikasi telah dihapus total"
echo "✓ Semua konfigurasi telah dibersihkan"
echo "✓ Semua repository telah dihapus"
echo "✓ Database MariaDB telah dihapus total"
echo "✓ Cache dan temporary files telah dibersihkan"
echo ""
echo "🚀 Sistem siap untuk install fresh!"
echo ""
echo "Jalankan: sudo bash install.sh"
echo ""
echo "=========================================="
