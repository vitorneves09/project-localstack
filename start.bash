#!/bin/bash

# Variáveis
LOCALSTACK_CONTAINER="localstack"
BUCKET_NAME=s3-localstack-dev
ENDPOINT_URL="http://localhost:4566"

# Checa dependências
command -v docker compose >/dev/null 2>&1 || { echo >&2 "Docker Compose não instalado. Saindo."; exit 1; }

# Iniciar o docker-compose (se ainda não rodar)
docker compose up -d

# Aguarda o LocalStack ficar disponível (timeout de 60s)
echo "Aguardando o LocalStack iniciar..."
for i in {1..30}; do
  if docker exec $LOCALSTACK_CONTAINER awslocal s3 ls >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

if ! docker exec $LOCALSTACK_CONTAINER awslocal s3 ls >/dev/null 2>&1; then
  echo "LocalStack não iniciou corretamente. Saindo."
  exit 1
fi

echo "LocalStack iniciado!"

# Verifica se o bucket existe
if docker exec $LOCALSTACK_CONTAINER awslocal s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Bucket '$BUCKET_NAME' já existe."
else
  echo "Criando bucket '$BUCKET_NAME'..."
  docker exec $LOCALSTACK_CONTAINER awslocal s3 mb s3://$BUCKET_NAME
  echo "Bucket '$BUCKET_NAME' criado."
fi

echo ""
echo "===================="
echo "Nome do Bucket: $BUCKET_NAME"
echo "===================="