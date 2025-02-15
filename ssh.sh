set -o allexport
source .env.local
set +o allexport

ssh root@$REMOTE_HOST
