#!/bin/bash
set -e

STATUS=$(curl -o /dev/null -s -w "%{http_code}" http://localhost/index.html)

if [ "$STATUS" != "200" ]; then
  echo "Validation failed. HTTP status: $STATUS"
  exit 1
fi

