#!/usr/bin/env bash

set -euo pipefail

out="${1:-schemas/}"
mkdir -p "$out"

tags=$(git ls-remote --refs --tags https://github.com/argoproj/argo-cd.git | cut -d/ -f3 | sort --general-numeric-sort --reverse | sed -n '1,200p')
bin="docker run -i --rm -v ${out}:/out/schemas ghcr.io/yannh/openapi2jsonschema:latest"

counter=0

function generate() {
  url=https://raw.githubusercontent.com/argoproj/argo-cd/${tag}/assets/swagger.json
  # prefix=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/main/${out}/${tag}/_definitions.json
  $bin -o "schemas/${tag}/standalone-strict" --expanded --stand-alone --strict "${url}"
  $bin -o "schemas/${tag}/standalone-strict" --stand-alone --strict "${url}"

  $bin -o "schemas/${tag}/standalone" --expanded --stand-alone "${url}"
  $bin -o "schemas/${tag}/standalone" --stand-alone "${url}"

  # NOTE: Who needs local huh?
  #
  # $bin -o "schemas/${tag}/local" --expanded "${url}"
  # $bin -o "schemas/${tag}/local" "${url}"

  # TODO: I don't know what to name this. But it just... doesn't neccessary
  #
  # $bin -o "schemas/${tag}" --expanded --kubernetes --prefix "${prefix}" "${url}"
  # $bin -o "schemas/${tag}" --kubernetes --prefix "${prefix}" "${url}"
} 1>/dev/null

tag='master'

generate

for tag in $tags; do
  counter=$((counter + 1))
  if [ -d "${out}/${tag}" ]; then
    continue
  fi
  printf -- '---\n'
  echo "Order: $counter: Generating for $tag..."
  generate || true
done
