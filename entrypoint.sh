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

if [[ $4 == "namespace_files" ]]; then
  /app/kestra namespace files update "$1" "$2" "$3" --server="$5" "$auth" $delete $tenant
else
  /app/kestra "$4" namespace update "$1" "$2" --server="$5" "$auth" $delete $tenant
fi
