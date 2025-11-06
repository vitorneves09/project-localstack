#!/bin/bash

# Variáveis
LOCALSTACK_CONTAINER="localstack"
BUCKET_NAME=s3-localstack-dev

# Verifica se o LocalStack está rodando
if ! docker ps --format '{{.Names}}' | grep -q "^${LOCALSTACK_CONTAINER}$"; then
  echo "Erro: LocalStack não está rodando. Execute o script start.bash primeiro."
  exit 1
fi

# Verifica se o bucket existe
if ! docker exec $LOCALSTACK_CONTAINER awslocal s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "Erro: Bucket '$BUCKET_NAME' não existe."
  exit 1
fi

echo "Listando objetos no bucket '$BUCKET_NAME'..."

echo "Deseja informar a pasta? Digite 's' para sim ou 'n' para não:"
read -r resposta

if [[ "$resposta" == "s" ]]; then
  echo "Informe o diretório onde os arquivos estão localizados:"
  read -r diretorio
  echo "Listando objetos no bucket '$BUCKET_NAME' no diretório '$diretorio'..."
  docker exec $LOCALSTACK_CONTAINER awslocal s3 ls s3://$BUCKET_NAME/"$diretorio" --recursive
else
  echo "Listando todos os objetos no bucket '$BUCKET_NAME'..."
  docker exec $LOCALSTACK_CONTAINER awslocal s3 ls s3://$BUCKET_NAME --recursive
fi 
