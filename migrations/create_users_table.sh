#!/bin/bash
set -o allexport
source .env.local 2>/dev/null || { echo "Файл .env.local не знайдено!"; exit 1; }
set +o allexport

# Налаштування підключення до бази
DB_NAME=${PG_DATABASE:-"default_db"}
DB_USER=${PG_USER:-"default_user"}
DB_PASSWORD=${PG_PASSWORD:-"default_password"}
DB_HOST=${PG_HOST:-"localhost"}
DB_PORT=${PG_PORT:-"5432"}

export PGPASSWORD=$DB_PASSWORD

# Перевірка, чи існує таблиця
TABLE_EXISTS=$(psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" -tAc "SELECT to_regclass('public.contacts');")

if [[ "$TABLE_EXISTS" == "contacts" ]]; then
  echo "✅ Таблиця 'contacts' вже існує. Міграція не потрібна."
else
  echo "⚠️  Таблиця 'contacts' не знайдена. Виконую міграцію..."
  psql -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" -d "$DB_NAME" <<EOF
  CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    contact_name TEXT NOT NULL,
    telegram_id BIGINT UNIQUE NULL,
    birthday DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
EOF
  echo "✅ Міграція виконана успішно!"
fi

unset PGPASSWORD
