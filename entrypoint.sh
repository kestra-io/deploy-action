#!/bin/bash

# Set up auth if required
auth=""
if [[ $6 && $7 ]]; then
    auth="--user=$6:$7"
fi

# Check if we delete or not resources
delete=""
if [[ $8 == true ]]; then
  delete="--delete"
fi

# Check if there is a tenant id
tenant=""
if [[ $9 ]]; then
  tenant="--tenant=$9"
fi

# Check if there is a API Token
apiToken=""
if [[ ${10} ]]; then
  apiToken="--api-token=${10}"
fi

# Track usage
CONFIG=$(curl -s https://api.kestra.io/v1/config)
PH_TOKEN=$(echo "$CONFIG" | sed -E  's/.*"token":"([^"]+)".*/\1/')
PH_API_HOST=$(echo "$CONFIG" | sed -E  's/.*"apiHost":"([^"]+)".*/\1/')
PH_ID=$(echo "$CONFIG" | sed -E  's/.*"id":"([^"]+)".*/\1/')

curl -v -L -H "Content-Type: application/json" -d '{
    "api_key": "'"$PH_TOKEN"'",
    "event": "Github Actions",
    "distinct_id": "'"$PH_ID"'",
    "properties": {
        "gha": {
            "name": "deploy-action",
            "resource": "'"$4"'",
            "namespace": "'"$1"'"
        }
    }
}' "$PH_API_HOST"capture/ > /dev/null

# Run it
if [[ $4 == "namespace_files" ]]; then
  /app/kestra namespace files update "$1" "$2" "$3" --server="$5" $auth $delete $tenant $apiToken
else
  /app/kestra "$4" namespace update "$1" "$2" --server="$5" $auth $delete $tenant $apiToken
fi
