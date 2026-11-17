#!/bin/bash
# Inicializa Couchbase (cluster + bucket). Idempotente: se puede ejecutar varias veces.
set -u

CLI="couchbase-cli"
URL="http://${CB_HOST}:8091"

echo "[init] Intentando inicializar el cluster..."
$CLI cluster-init -c "$URL" \
  --cluster-username "$CB_USER" \
  --cluster-password "$CB_PASSWORD" \
  --cluster-name mucard \
  --services data,index,query \
  --cluster-ramsize 1024 \
  --cluster-index-ramsize 256 \
  --index-storage-setting default || echo "[init] Cluster ya inicializado (se continua)."

echo "[init] Creando bucket ${CB_BUCKET}..."
$CLI bucket-create -c "$URL" \
  --username "$CB_USER" --password "$CB_PASSWORD" \
  --bucket "$CB_BUCKET" \
  --bucket-type couchbase \
  --bucket-ramsize 256 || echo "[init] El bucket ya existe (se continua)."

echo "[init] Listo. UI: http://localhost:8091"
