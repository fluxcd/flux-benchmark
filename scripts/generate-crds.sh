#!/bin/bash
repo_root=$(git rev-parse --show-toplevel)
template_file="$repo_root/scripts/crd_template.yaml"
tmpdir="${TMPDIR:-/tmp}"
for ((i=1; i<=$CRD_COUNT; i++))
do
  crd_name="$i"
  sed "s/CRD_COUNT/$crd_name/" $template_file > "$tmpdir/generated_crd_$i.yaml"
  kubectl apply -f "$tmpdir/generated_crd_$i.yaml" > /dev/null
done
echo "Generated $crds CRDs"
