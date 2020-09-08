#!/bin/bash

find . -depth -type f -name "*.txt" \
-exec sh -c \
'mv -- "$1" "$(dirname "$1")/$(basename "$1" .txt).sh"' _ '{}' \;

find . -name "*.sh" -exec chmod +x {} \;


