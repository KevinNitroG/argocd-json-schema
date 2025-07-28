#!/usr/bin/env bash

set -euo pipefail

out="${1:-schemas/}"
mkdir -p "$out"

# TODO: When it fully generated, no need to sort
tags=$(git ls-remote --refs --tags https://github.com/argoproj/argo-cd.git | cut -d/ -f3 | sort --general-numeric-sort --reverse | sed -n '1,100p')
bin="docker run -i --rm -v ${out}:/out/schemas ghcr.io/yannh/openapi2jsonschema:latest"

for tag in master $tags; do
  if [ -d "${out}/${tags}" ]; then
    continue
  fi

  url=https://raw.githubusercontent.com/argoproj/argo-cd/${tag}/assets/swagger.json
  printf -- '---\n'
  echo "Generating for tag: $tag..."
  # prefix=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/main/${out}/${tag}/_definitions.json

  {
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
  } 1>/dev/null || true # In case it doesn't exist
done
