# Настройка Ubuntu Server + 3x-ui + SSL

## 1. Первичная настройка и безопасность

### На локальном ПК
```bash
# Генерация SSH-ключа (если отсутствует)
ssh-keygen -t ed25519 -C "admin@vps"

# Копирование ключа на сервер
ssh-copy-id root@{your_ip}
```

### На сервере (под root)
```bash
# Обновление системы
apt update && apt upgrade -y

# Создание sudo-пользователя (замените admin на нужное имя)
adduser admin
usermod -aG sudo admin

# Перенос SSH-ключей root к созданной учетной записи
rsync --archive --chown=admin:admin ~/.ssh /home/admin/
```

### Настройка SSH (`/etc/ssh/sshd_config`)
Выполните команды для настройки безопасности SSH и смены порта на `2222`:

```bash
sudo sed -i 's/^#\?Port.*/Port 2222/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?MaxAuthTries.*/MaxAuthTries 3/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?ClientAliveInterval.*/ClientAliveInterval 300/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?ClientAliveCountMax.*/ClientAliveCountMax 2/' /etc/ssh/sshd_config

# Перезапуск службы SSH
sudo systemctl restart ssh
```

> **Важно:** Не закрывайте текущую сессию, пока не проверите подключение в новом окне терминала:  
> `ssh -p 2222 admin@{your_ip}`

---

## 2. Базовая конфигурация и фаервол

### Базовый софт, Fail2ban и автообновления
```bash
sudo apt install -y curl wget htop nano git unzip zip fail2ban unattended-upgrades certbot
sudo systemctl enable --now fail2ban
sudo dpkg-reconfigure -plow unattended-upgrades
```

### Настройка UFW (Фаервол)
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 2222/tcp comment 'SSH Port'
sudo ufw allow 80,443/tcp comment 'Web / SSL'
sudo ufw allow 2053/tcp comment '3x-ui Panel'
sudo ufw --force enable
```

### Настройка SWAP (2 GB) и часового пояса
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sudo timedatectl set-timezone Europe/Moscow
```

---

## 3. Установка и запуск 3x-ui

### Шаг 1: Загрузка архива (Ручная установка)

**На локальном ПК:**
```bash
wget https://github.com/mhsanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz
scp -P 2222 x-ui-linux-amd64.tar.gz admin@{your_ip}:/tmp/
```

### Шаг 2: Установка на сервере
```bash
cd /tmp
tar -xzf x-ui-linux-amd64.tar.gz
chmod +x x-ui/x-ui
sudo mv x-ui/x-ui /usr/local/bin/
sudo mkdir -p /usr/local/x-ui
sudo cp -r x-ui/* /usr/local/x-ui/
rm -rf x-ui-linux-amd64.tar.gz x-ui
```

### Шаг 3: Создание systemd-сервиса
```bash
sudo bash -c 'cat > /etc/systemd/system/x-ui.service' << 'EOF'
[Unit]
Description=x-ui Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/x-ui
WorkingDirectory=/usr/local/x-ui
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now x-ui
```

* Первичный доступ к панели: `http://{your_ip}:2053`
* Авторизация по умолчанию: `admin` / `admin` *(обязательно смените пароль при первом входе)*

---

## 4. Выпуск SSL-сертификата (Let’s Encrypt)

### Получение сертификата
```bash
sudo certbot certonly --standalone -d domain.ru --agree-tos --email admin@domain.ru
```

### Пути к ключам:
* **Cert:** `/etc/letsencrypt/live/domain.ru/fullchain.pem`
* **Key:** `/etc/letsencrypt/live/domain.ru/privkey.pem`

### Настройка автообновления
```bash
(sudo crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet --post-hook 'systemctl restart x-ui'") | sudo crontab -
```

### Привязка SSL в панели 3x-ui
1. Откройте `http://{your_ip}:2053`
2. Перейдите в **Panel Settings** → **Security**
3. Включите **HTTPS**
4. Укажите пути:
   * **Public Key Path:** `/etc/letsencrypt/live/domain.ru/fullchain.pem`
   * **Private Key Path:** `/etc/letsencrypt/live/domain.ru/privkey.pem`
5. Сохраните настройки и перезапустите службу при необходимости.
6. Вход в панель с этого момента: `https://domain.ru:2053`

---

## 5. Диагностика и проверка

```bash
# Статус службы 3x-ui
sudo systemctl status x-ui

# Проверка прослушиваемых портов
sudo ss -tlnp | grep -E '2222|2053|80|443'

# Тест автообновления SSL-сертификата
sudo certbot renew --dry-run
```
