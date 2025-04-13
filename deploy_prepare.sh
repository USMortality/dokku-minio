#!/usr/bin/env sh

ssh co "dokku storage:mount $APP_NAME /var/lib/dokku/data/storage/$APP_NAME:/data"

ssh co "dokku ports:set $APP_NAME http:80:5000 http:8443:8443 http:9001:9001"

ssh co "dokku domains:add $APP_NAME s3.mortality.watch s3-www.mortality.watch s3-gate.mortality.watch"

read -sp "Enter Root Password: " ROOT_PASSWORD
echo

ssh co "dokku config:set $APP_NAME --no-restart \
  CLIENT_MAX_BODY_SIZE=10M \
  MINIO_BROWSER_REDIRECT_URL=https://admin-s3.mortality.watch \
  MINIO_ROOT_PASSWORD=$ROOT_PASSWORD \
  MINIO_ROOT_USER=minio \
  MINIO_SERVER_URL=https://s3.mortality.watch"
