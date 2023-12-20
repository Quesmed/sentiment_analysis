# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/engine/reference/builder/

ARG PYTHON_VERSION=3.11.5
FROM python:${PYTHON_VERSION} as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.
RUN apt-get update
RUN apt-get install git libpq-dev gcc libc-dev g++ libffi-dev libxml2 libffi-dev unixodbc-dev jq -y
RUN python -m pip install torch
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

# Copy the source code into the container.
COPY datasets datasets
COPY prodigy.json prodigy.json

ARG POSTGRES_HOST
ARG POSTGRES_DB
ARG POSTGRES_PORT
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

RUN jq '.db = "postgresql"' prodigy.json | \
    jq ".db_settings.postgresql.db = \"$POSTGRES_DB\"" | \
    jq ".db_settings.postgresql.host = \"$POSTGRES_HOST\"" | \
    jq ".db_settings.postgresql.port = \"$POSTGRES_PORT\"" | \
    jq ".db_settings.postgresql.user = \"$POSTGRES_USER\"" | \
    jq ".db_settings.postgresql.password = \"$POSTGRES_PASSWORD\"" > prodigy2.json
RUN mv prodigy2.json prodigy.json

# Expose the port that the application listens on.
EXPOSE 8080
