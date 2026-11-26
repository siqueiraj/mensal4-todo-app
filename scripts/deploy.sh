#!/bin/bash
set -euo pipefail

cd /opt/todo-app

NOVA_VERSAO="${1:?Informe a versao}"
VERSAO_ANTERIOR=$(cat .version 2>/dev/null || true)

export APP_VERSION="$NOVA_VERSAO"

echo "Preparando versao: $NOVA_VERSAO"

docker compose -f compose.production.yml pull

if docker compose -f compose.production.yml up -d --wait --wait-timeout 180 \
    && curl -fsS http://127.0.0.1:8080/todos >/dev/null; then

    printf 'APP_VERSION=%s\n' "$NOVA_VERSAO" > .release.env
    echo "$NOVA_VERSAO" > .version
    echo "Deploy concluido com sucesso!"

else
    echo "Falha no deploy!"

    if [ -n "$VERSAO_ANTERIOR" ]; then
        echo "Restaurando versao: $VERSAO_ANTERIOR"

        export APP_VERSION="$VERSAO_ANTERIOR"

        docker compose -f compose.production.yml up -d --wait --wait-timeout 180
        curl -fsS http://127.0.0.1:8080/todos >/dev/null

        echo "Rollback concluido!"
    else
        echo "Nenhuma versao anterior disponivel."
    fi

    exit 1
fi
