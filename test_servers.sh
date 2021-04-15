#!/bin/bash
set -uo pipefail

failed=0

for i in {1..50}; do
  bash connaisseur/tests/integration/integration-test.sh >> test.log 2>&1
  if [[ $? -ne 0 ]]; then
    failed=$((${failed} + 1))
    echo "[FAIL] Failed for try $i"
    make uninstall
    make annihilate
    kubectl delete ns connaisseur
  fi
done
echo "$failed failed"
