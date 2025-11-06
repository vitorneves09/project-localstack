#!/bin/bash
BUCKET_NAME=s3-marketplace-financeiro-dev

echo "Listando objetos no bucket '$BUCKET_NAME'..."

echo "Deseja informar a pasta? Digite 's' para sim ou 'n' para não:"
read -r resposta

if [[ "$resposta" == "s" ]]; then
  echo "Informe o diretório onde os arquivos estão localizados:"
  read -r diretorio
  echo "Listando objetos no bucket '$BUCKET_NAME' no diretório '$diretorio'..."
  docker exec localstack awslocal s3 ls $BUCKET_NAME/"$diretorio" --recursive
else
  echo "Listando todos os objetos no bucket '$BUCKET_NAME'..."
  docker exec localstack awslocal s3 ls $BUCKET_NAME --recursive
fi 
