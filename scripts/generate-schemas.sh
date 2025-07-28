#!/usr/bin/env bash

set -euo pipefail

out="${1:-schemas/}"
mkdir -p "$out"

tags=$(git ls-remote --refs --tags https://github.com/argoproj/argo-cd.git | cut -d/ -f3)
bin="docker run -i --rm -v ${out}:/out/schemas ghcr.io/yannh/openapi2jsonschema:latest"

for tag in $tags main; do
  url=https://raw.githubusercontent.com/argoproj/argo-cd/${tag}/assets/swagger.json
  # prefix=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/main/${out}/${tag}/_definitions.json

  if [ ! -d "${out}/${tag}/standalone-strict" ]; then
    $bin -o "schemas/${tag}/standalone-strict" --expanded --stand-alone --strict "${url}"
    $bin -o "schemas/${tag}/standalone-strict" --stand-alone --strict "${url}"
  fi

  if [ ! -d "${out}/${tag}/standalone" ]; then
    $bin -o "schemas/${tag}/standalone" --expanded --stand-alone "${url}"
    $bin -o "schemas/${tag}/standalone" --stand-alone "${url}"
  fi

  if [ ! -d "${out}/${tag}/local" ]; then
    $bin -o "schemas/${tag}/local" --expanded "${url}"
    $bin -o "schemas/${tag}/local" "${url}"
  fi

  # TODO: I don't know what to name this. But it just... doesn't neccessary
  #
  # if [ ! -d "${out}/${tag}" ]; then
  #   $bin -o "schemas/${tag}" --expanded --kubernetes --prefix "${prefix}" "${url}"
  #   $bin -o "schemas/${tag}" --kubernetes --prefix "${prefix}" "${url}"
  # fi
done
