node v 18.0.0

### Setup:
install:
  postgresql
  pnpm
  nvm

create .env.local
```
PORT=1880
DOMAIN=xxxx
REMOTE_HOST=x.x.x.x

TG_BOT_NAME=xxx
TG_API_TOKEN=xxxxx

PG_PORT=5432
PG_USER=postgres
PG_HOST=localhost
PG_DATABASE=ecobank
PG_PASSWORD=postgres
```

### Run local:
pnpm i
pnpm start

open http://localhost:1880

### Links
[t.me/ecobank_b636yn_bot](https://t.me/ecobank_b636yn_bot)

https://core.telegram.org/bots/api
