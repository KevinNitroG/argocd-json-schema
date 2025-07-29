# ArgoCD JSON Schema

This repository provides JSON schemas for ArgoCD resources. These schemas can be used with the [YAML Language Server](https://github.com/redhat-developer/yaml-language-server) to enable validation and autocompletion in your editor.

![Repo size](https://img.shields.io/github/repo-size/KevinNitroG/argocd-json-schema?style=for-the-badge&color=b4befe&labelColor=363a4f)

---

## Usage

### YAML Language Server

To use a schema, add the following comment at the top of your YAML file:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/refs/heads/main/schemas/{version}/{type}/{resource}.json
```

Replace `{version}`, `{type}`, and `{resource}` as follows:

- `{version}`: Use `main` or a release tag from the [argoproj/argo-cd](https://github.com/argoproj/argo-cd) repository.
- `{type}`:
  - `standalone`: No references to external resources.
  - `standalone-strict`: Like `standalone`, but does not allow additional properties.
- `{resource}`: The resource name (e.g., `deployment`).

[!WARNING]
>
> The `standalone-strict` one doesn't allow `apiVersion` and `kind`. Consider using `standalone` instead.

**Example:**

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/refs/heads/main/schemas/v3.0.9/standalone/v1alpha1applicationset.json
```

---

## Additional Information

### Notes

- For Kubernetes and ArgoCD snippets in Neovim, see [kubernetes-schema-snippets.nvim](https://github.com/KevinNitroG/kubernetes-schema-snippets.nvim).
- The tool [yannh/openapi2jsonschema](https://github.com/yannh/openapi2jsonschema) does not work with the `--kubernetes` argument. As a result, resource names include the version before the resource name.

### Acknowledgements

- <https://github.com/argoproj/argo-cd>
- <https://github.com/yannh/kubernetes-json-schema>
- <https://github.com/argoproj/argo-schema-generator/issues/9>
- <https://github.com/yannh/openapi2jsonschema>
