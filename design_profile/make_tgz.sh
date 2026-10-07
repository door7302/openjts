#!/usr/bin/env bash
# Create a .tgz archive of each subfolder, named after the folder.
# Ex. tar -zcvf ddos.tgz ddos/

set -euo pipefail

cd "$(dirname "$0")"

for dir in */; do
    name="${dir%/}"
    tar -zcvf "${name}.tgz" "$dir"
done

mv *.tgz ../compose/jtso/profiles
