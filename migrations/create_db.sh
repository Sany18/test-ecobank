#!/bin/bash
set -o allexport
source ./.env.local 2>/dev/null || { echo "Файл .env.local не знайдено!"; exit 1; }
set +o allexport

# Налаштування підключення до бази
DB_NAME=${PG_DATABASE:-"default_db"}
DB_USER=${PG_USER:-"default_user"}
DB_PASSWORD=${PG_PASSWORD:-"default_password"}
DB_HOST=${PG_HOST:-"localhost"}
DB_PORT=${PG_PORT:-"5432"}

export PGPASSWORD=$DB_PASSWORD

# Перевірка, чи існує база даних
DB_EXISTS=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -tAc "SELECT 1 FROM pg_database WHERE datname='ecobank'")

if [[ "$DB_EXISTS" == "1" ]]; then
  echo "✅ База даних 'ecobank' вже існує. Міграція не потрібна."
else
  echo "⚠️  База даних 'ecobank' не знайдена. Виконую створення..."
  psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" <<EOF
  CREATE DATABASE ecobank;
EOF
  echo "✅ База даних 'ecobank' була успішно створена!"
fi

unset PGPASSWORD
