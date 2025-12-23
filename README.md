# Ubuntu 22.04 Development Environment - Auto Install Scripts

Script otomatis untuk instalasi lengkap Development Environment di Ubuntu 22.04 LTS.

---

## 📦 Apa yang Diinstall

### Browsers & Editors
- Google Chrome (latest)
- Microsoft Edge (latest)
- Visual Studio Code (latest)
- Sublime Text (latest)

### Web Server
- Nginx 1.29 (mainline)

### PHP-FPM Multiple Versions
- PHP 7.4-FPM + 50+ extensions
- PHP 8.0-FPM + 50+ extensions
- PHP 8.1-FPM + 50+ extensions
- PHP 8.2-FPM + 50+ extensions
- PHP 8.3-FPM + 50+ extensions

**Extensions**: cli, common, mysql, zip, curl, gd, mbstring, xml, bcmath, phpdbg, cgi, embed, tokenizer, xmlrpc, imagick, dev, imap, soap, json, opcache, redis, intl, bz2, calendar, ctype, dba, dom, enchant, exif, fileinfo, ftp, gettext, gmp, iconv, mysqli, odbc, pdo, pdo-mysql, pdo-odbc, pdo-sqlite, phar, posix, pspell, simplexml, snmp, sockets, sqlite3, tidy, xmlreader, xmlwriter, xsl, mysqlnd, memcache, memcached, xdebug

### JavaScript Runtime
- Node.js 22
- NPM (latest)
- PM2 (process manager)
- Bun.js (latest)

### Database
- MariaDB 11.4
- phpMyAdmin (latest) → `/usr/share/nginx/html/dbmyadmin`

### Tools
- Composer (PHP dependency manager)
- Certbot (SSL manager dengan nginx plugin)
- Bind9 (DNS Server)

---

## 🚀 Cara Install

```bash
# 1. Download/Clone repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# 2. Beri permission
chmod +x install.sh uninstall.sh

# 3. Jalankan install
bash install.sh

# atau jika bukan root user
sudo bash install.sh
```

Waktu instalasi: ±15-30 menit

---

## 🗑️ Cara Uninstall

```bash
bash uninstall.sh
```

Script akan menghapus:
- Semua aplikasi yang diinstall
- Semua konfigurasi
- Semua database
- Semua repository yang ditambahkan
- Cache dan temporary files

---

## 📝 Catatan

### Setelah Install:
1. Secure MariaDB: `mysql_secure_installation`
2. Akses phpMyAdmin: `http://YOUR_IP/dbmyadmin`
3. Test PHP: `http://YOUR_IP/info.php`

### PHP-FPM Sockets:
```
PHP 7.4: /run/php/php7.4-fpm.sock
PHP 8.0: /run/php/php8.0-fpm.sock
PHP 8.1: /run/php/php8.1-fpm.sock
PHP 8.2: /run/php/php8.2-fpm.sock
PHP 8.3: /run/php/php8.3-fpm.sock
```

### Ganti PHP CLI Default:
```bash
update-alternatives --config php
```

### Ganti PHP di Nginx:
Edit `/etc/nginx/conf.d/default.conf`, ubah baris `fastcgi_pass` ke versi PHP yang diinginkan, lalu `systemctl reload nginx`

---

**That's it!** Simple dan straight to the point. 🚀
