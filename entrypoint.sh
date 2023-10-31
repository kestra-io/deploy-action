#!/bin/bash

# Set up auth if required
auth=""
if [[ $5 && $6 ]]; then
    auth="--user=$5:$6"
fi

# Check if we delete or not resources
delete=""
if [[ $7 == true ]]; then
  delete="--delete"
fi

# Check if there is a tenant id
tenant=""
if [[ $8 ]]; then
  tenant="--tenant=$8"
fi

if [[ $3 == 'namespace_files' ]]; then
  /app/kestra namespace files update "$1" "$2" --server="$4" "$auth" $delete "$tenant"
else
  /app/kestra "$3" namespace update "$1" "$2" --server="$4" "$auth" $delete "$tenant"
fi
