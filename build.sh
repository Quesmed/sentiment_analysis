#!/bin/sh

[ ! -f local.env ] || export $(grep -v '^#' local.env | xargs)

docker build . -t prodigy-quesmed-comments \
  --build-arg="POSTGRES_HOST=$POSTGRES_HOST" \
  --build-arg="POSTGRES_PORT=$POSTGRES_PORT" \
  --build-arg="POSTGRES_USER=$POSTGRES_USER" \
  --build-arg="POSTGRES_PASSWORD=$POSTGRES_PASSWORD" \
  --build-arg="POSTGRES_DB=$POSTGRES_DB"