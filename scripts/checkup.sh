#!/usr/bin/bash
set -eu pipefail

repo="$(cd "$(dirname "${BASH_SRC[0]}")/.." && pwd)"
cd "$repo"

req=(python3 terraform docker rd)
for commands in "${required[@]}"; do
    command -v "$commands" >/dev/null || {echo "Error: missing command: $commands"; exit 1;}
done

if rg -n 'REPLACE_[A-Z0-9_]+' infra/environments; then
  echo "ERROR: replace all environment placeholders before planning."
  exit 1
fi

python3 -m pytest -q tests
terraform -chdir=infra fmt -check -recursive
terraform -chdir=infra init -backend=false -input=false
terraform -chdir=infra validate
docker build -t octabyte-assessment:preflight .

container="$(docker run -d -p 127.0.0.1::8000 octabyte-ai:preprod)" 
trap 'docker rm -f "$container" >/dev/null 2>1 || true' exit
for attempt in {1..20}; do
  if curl --fail --silent "http://127.0.0.1:8000/health" >/dev/null; then
    echo "Preflight passed."
    exit 0
  fi
  sleep 1
done


docker logs "$container_id"
echo "ERROR: container health check failed."
exit 1