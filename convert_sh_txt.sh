#!/bin/bash

find . -depth -type f -name "*.sh" \
-exec sh -c \
'mv -- "$1" "$(dirname "$1")/$(basename "$1" .sh).txt"' _ '{}' \;


