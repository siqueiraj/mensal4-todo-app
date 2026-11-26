#!/bin/bash
set -euo pipefail

URL="${1:-http://localhost}"
ID=""

cleanup() {
    if [ -n "$ID" ]; then
        curl -fsS -X DELETE "$URL/todos/$ID" >/dev/null || true
    fi
}
trap cleanup EXIT

echo "1. Testando frontend..."
curl -fsS "$URL/" >/dev/null

echo "2. Listando tarefas..."
curl -fsS "$URL/todos" >/dev/null

echo "3. Criando tarefa..."
ID=$(curl -fsS -X POST "$URL/todos" \
    -H "Content-Type: application/json" \
    -d '{"text":"Teste automatizado CI/CD"}' |
    python3 -c 'import sys,json; print(json.load(sys.stdin)["_id"])')

echo "4. Atualizando tarefa..."
curl -fsS -X PATCH "$URL/todos/$ID" |
    python3 -c 'import sys,json; assert json.load(sys.stdin)["completed"] is True'

echo "5. Excluindo tarefa..."
curl -fsS -X DELETE "$URL/todos/$ID" >/dev/null

echo "6. Confirmando exclusao..."
curl -fsS "$URL/todos" |
    python3 -c 'import sys,json; assert all(t["_id"] != sys.argv[1] for t in json.load(sys.stdin))' "$ID"

ID=""
echo "Todos os testes passaram!"
