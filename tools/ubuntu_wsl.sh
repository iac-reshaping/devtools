#!/usr/bin/env bash

set -euo pipefail

echo () {
    printf "\n%b\n" "[iac] $1"
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Running additional script from ${SCRIPT_DIR}"

"${SCRIPT_DIR}/ubuntu.sh"
