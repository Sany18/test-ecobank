#!/bin/bash

# Завантажуємо змінні середовища
set -o allexport
source .env.local
set +o allexport

echo "Підключення до $REMOTE_HOST і перегляд логів..."

# Підключення до сервера та перегляд логів
ssh root@$REMOTE_HOST "tail -f /var/www/${DOMAIN}/app.log"
