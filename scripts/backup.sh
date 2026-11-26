#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p backups

ARQUIVO="backups/todo-app-$(date +%Y-%m-%d_%H-%M-%S).archive.gz"

docker exec mongo-todo sh -c 'mongodump --username "$MONGO_INITDB_ROOT_USERNAME" --password "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin --db todo-app --archive --gzip' > "$ARQUIVO.tmp"

gzip -t "$ARQUIVO.tmp"
mv "$ARQUIVO.tmp" "$ARQUIVO"

echo "Backup concluido: $ARQUIVO"
