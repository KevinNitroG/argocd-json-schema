#!/usr/bin/env bash

set -euo pipefail

out="${1:-schemas/}"
mkdir -p "$out"

readarray -t tags < <(
  git ls-remote --refs --tags https://github.com/argoproj/argo-cd.git |
    cut -d/ -f3 |
    sort --general-numeric-sort --reverse |
    sed -n '1,200p'
)

special_tags=('master' 'stable')

bin="docker run -i --rm -v ${out}:/out/schemas ghcr.io/yannh/openapi2jsonschema:latest"

function generate() {
  url=https://raw.githubusercontent.com/argoproj/argo-cd/${tag}/assets/swagger.json
  # prefix=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/main/${out}/${tag}/_definitions.json

  $bin -o "schemas/${tag}/standalone-strict" --expanded --stand-alone --strict "${url}" >/dev/null &
  $bin -o "schemas/${tag}/standalone-strict" --stand-alone --strict "${url}" >/dev/null &
  $bin -o "schemas/${tag}/standalone" --expanded --stand-alone "${url}" >/dev/null &
  $bin -o "schemas/${tag}/standalone" --stand-alone "${url}" >/dev/null &

  wait

  # NOTE: Who needs local huh?
  #
  # $bin -o "schemas/${tag}/local" --expanded "${url}" >/dev/null &
  # $bin -o "schemas/${tag}/local" "${url}" >/dev/null &

  # TODO: I don't know what to name this. But it just... doesn't neccessary
  #
  # $bin -o "schemas/${tag}" --expanded --kubernetes --prefix "${prefix}" "${url}" >/dev/null &
  # $bin -o "schemas/${tag}" --kubernetes --prefix "${prefix}" "${url}" >/dev/null &

  # wait
}

counter=0

for tag in "${special_tags[@]}" "${tags[@]}"; do
  counter=$((counter + 1))
  printf -- '---\n'
  if ! echo "${special_tags[*]}" | grep -q -F -w "${tag}" && [[ -d "${out}/${tag}" ]]; then
    echo "Order: $counter: Skip generating for $tag"
    continue
  fi
  echo "Order: $counter: Generating for $tag..."
  generate
done
