#!/bin/bash
VAULT_URL=http://127.0.0.1
VAULT_PORT=8200
VAULT_API_VERSION=v1

echo "Enabling AppRole"
curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" -d '{"type":"approle"}' \
    $VAULT_URL:$VAULT_PORT/$VAULT_API_VERSION/sys/auth/approle

ROLE_NAME=ratings-service-role

echo "Deleting $ROLE_NAME"
curl -X DELETE -H "X-Vault-Token:$VAULT_TOKEN" \
    $VAULT_URL:$VAULT_PORT/$VAULT_API_VERSION/auth/approle/role/$ROLE_NAME

echo "Creating $ROLE_NAME"
curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" -d \
    '{"policies":"ratings-service-policy", 
    "secret_id_ttl":"60s",
    "token_ttl":"60s"}' \
    $VAULT_URL:$VAULT_PORT/$VAULT_API_VERSION/auth/approle/role/$ROLE_NAME

#echo "Creating a new secret identifier under $ROLE_NAME"
#curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" \
#    $VAULT_URL:$VAULT_PORT/$VAULT_API_VERSION/auth/approle/role/$ROLE_NAME/secret-id

#echo "Creating permanent token for $ROLE_NAME"
#curl -X POST -H "X-Vault-Token:$VAULT_TOKEN" \
#    $VAULT_URL:$VAULT_PORT/$VAULT_API_VERSION/auth/token/create
