#!/bin/sh

[ ! -f .env ] || export $(grep -v '^#' .env | xargs)

docker build . -t 142412772381.dkr.ecr.eu-west-1.amazonaws.com/prodigy-quesmed-comments \
  --build-arg="POSTGRES_HOST=$POSTGRES_HOST" \
  --build-arg="POSTGRES_PORT=$POSTGRES_PORT" \
  --build-arg="POSTGRES_USER=$POSTGRES_USER" \
  --build-arg="POSTGRES_PASSWORD=$POSTGRES_PASSWORD" \
  --build-arg="POSTGRES_DB=$POSTGRES_DB"
aws ecr get-login-password | docker login --username AWS --password-stdin 142412772381.dkr.ecr.eu-west-1.amazonaws.com
docker push 142412772381.dkr.ecr.eu-west-1.amazonaws.com/prodigy-quesmed-comments