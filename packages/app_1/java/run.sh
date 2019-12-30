#!/bin/bash

set -euo pipefail
RUNFILES=${BASH_SOURCE[0]}.runfiles
for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done

echo "Arguments:" $@
which hello
hello