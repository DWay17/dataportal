#!/bin/sh
export COMPOSE_PROJECT=${DATA_PORTAL_COMPOSE_PROJECT:-dataportal}
#docker compose -p "$COMPOSE_PROJECT" -f docker-compose.vfps.yml up -d
docker compose --env-file .env --env-file project.env -p "$COMPOSE_PROJECT" -f docker-compose.yml up -d

