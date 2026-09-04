#!/bin/sh
export COMPOSE_PROJECT=${DATA_PORTAL_COMPOSE_PROJECT:-dataportal}
#docker compose -p "$COMPOSE_PROJECT" -f docker-compose.vfps.yml up -d
# ln -vs ~/projects/KePop/kepop_2026-08/dimp_dup_base.yaml dimp_dup_project.yaml
# ln -vs ~/projects/KePop/kepop_2026-08/kepop.env project.env
export DIMP_DUP_YAML_PATH="dimp_dup_project.yaml"
docker compose --env-file .env --env-file project.env -p "$COMPOSE_PROJECT" -f docker-compose.yml up -d
