# Argocd JSON Schema

This repository generates JSON schemas for ArgoCD resources. These schemas can be used with the [YAML Language Server](https://github.com/redhat-developer/yaml-language-server) to enable validation and autocompletion in your editor.

---

## Usage

### yaml language server

Add the following comment to the top of your YAML files to reference the schema:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/refs/heads/main/schemas/{version}/{type}/{resource}.json
```

Replace `{version}`, `{type}`, and `{resource}` with the appropriate values:

- `{version}`: Use `main` or a tag from the [argoproj/argo-cd](https://github.com/argoproj/argo-cd) repository.
- `{type}`:
  - `standalone`: No references to external resources.
  - `standalone-strict`: Like `standalone`, but does not allow additional properties.

Example:

```yaml
# yaml-language-server: $schema=https://raw.githubusercontent.com/KevinNitroG/argocd-json-schema/refs/heads/main/schemas/v3.0.9/standalone-strict/deployment.json
```

---

## Others

### Notes

- Snippets for kubernetes and argocd in neovim with [kubernetes-schema-snippets.nvim](https://github.com/KevinNitroG/kubernetes-schema-snippets.nvim)
- The tool [yannh/openapi2jsonschema](https://github.com/yannh/openapi2jsonschema) does not work with the `--kubernetes` argument. As a result, resource names include the version before the resource name.

### Acknowledgement

- <https://github.com/argoproj/argo-cd>
- <https://github.com/yannh/kubernetes-json-schema>
- <https://github.com/argoproj/argo-schema-generator/issues/9>
- <https://github.com/yannh/openapi2jsonschema>
