#!/bin/bash

RUNFILES=${BASH_SOURCE[0]}.runfiles
for d in $RUNFILES/*/bin; do PATH="$PATH:$d"; done