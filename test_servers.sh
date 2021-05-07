#!/bin/bash
set -uo pipefail

failed=0

for i in {1..50}; do
  shas=("29ce46d2183ecffa0b7447afa0abcae9c25c0977" "f521c1c81d72b16507fd0eb7b9f443cafae8112f" "cfc331114ea26c51bf99c76444a2b0187235a996")
  num_shas=${#shas[@]}
  for index in $(seq 0 $((${num_shas} - 1 )) | sort --random-sort); do
    current_sha=${shas[${index}]}
    echo "Iteration ${i}; testing sha ${current_sha}"
    git checkout ${current_sha}
    bash connaisseur/tests/integration/integration-test.sh >> "test_${current_sha}.log" 2>&1
    if [[ $? -ne 0 ]]; then
      failed=$((${failed} + 1))
      echo "[FAIL] Failed for try $i and sha ${current_sha}"
      make uninstall
      make annihilate
      kubectl delete ns connaisseur
      rm output.log
    fi
    git checkout "helm/"
  done
done
echo "$failed failed"
