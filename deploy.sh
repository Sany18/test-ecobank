set -o allexport
source .env.local
set +o allexport

echo "Deploying to $REMOTE_HOST"

# pnpm run build
rsync -av \
  --exclude=node_modules \
  --exclude=.git \
  . \
  root@${REMOTE_HOST}:/var/www/${DOMAIN}

# Build the project
ssh root@${REMOTE_HOST} << EOF
  source ~/.nvm/nvm.sh
  cd /var/www/${DOMAIN}
  source .env.local

  nvm use 18

  # Kill the process using the backend port if running
  # kill -9 $(lsof -t -i:1880)
  kill -9 \$(lsof -t -i:\${PORT}) > /dev/null 2>&1 || true

  # Install dependencies
  pnpm i

  # Run database migrations
  bash migrations/create_db.sh
  bash migrations/create_users_table.sh

  # echo "Node will start in detached mode"
  nohup pnpm run prod > /var/www/${DOMAIN}/app.log 2>&1 &
EOF

echo "Deployed to $REMOTE_HOST"
