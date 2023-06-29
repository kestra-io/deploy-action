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

/app/kestra "$3" namespace update "$1" "$2" --server="$4" "$auth" $delete