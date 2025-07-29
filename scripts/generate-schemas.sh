#!/usr/bin/env bash

set -euo pipefail

out="${1:-schemas/}"
mkdir -p "$out"

tags=$(git ls-remote --refs --tags https://github.com/argoproj/argo-cd.git | cut -d/ -f3 | sort --general-numeric-sort --reverse | sed -n '1,200p')

special_tags=$('main' 'stable')

container_id=$(docker run -d -v "${out}:/out/schemas" ghcr.io/yannh/openapi2jsonschema:latest sleep infinity)

function cleanup() {
  docker stop "$container_id" >/dev/null 2>&1 || true
  docker rm "$container_id" >/dev/null 2>&1 || true
}
trap cleanup EXIT

counter=0

function generate() {
  url=https://raw.githubusercontent.com/argoproj/argo-cd/${tag}/assets/swagger.json
  # prefix=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/main/${out}/${tag}/_definitions.json
  docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}/standalone-strict" --expanded --stand-alone --strict "${url}" >/dev/null &
  docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}/standalone-strict" --stand-alone --strict "${url}" >/dev/null &
  docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}/standalone" --expanded --stand-alone "${url}" >/dev/null &
  docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}/standalone" --stand-alone "${url}" >/dev/null &

  wait

  # NOTE: Who needs local huh?
  #
  # docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}/local" --expanded "${url}" &
  # docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}/local" "${url}" &

  # TODO: I don't know what to name this. But it just... doesn't neccessary
  #
  # docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}" --expanded --kubernetes --prefix "${prefix}" "${url}" &
  # docker exec "$container_id" openapi2jsonschema -o "schemas/${tag}" --kubernetes --prefix "${prefix}" "${url}" &

  #wait
}

for tag in "${special_tags[@]}" "${tags[@]}"; do
  counter=$((counter + 1))
  if [[ ${special_tags[*]} =~ $tag && -d "${out}/${tag}" ]]; then
    echo "Order: $counter: Skip generating for $tag"
    continue
  fi
  printf -- '---\n'
  echo "Order: $counter: Generating for $tag..."
  generate
done
