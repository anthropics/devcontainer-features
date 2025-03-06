
# Claude Code CLI (claude-code)

Installs the Claude Code CLI globally

## Example Usage

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|


## Customizations

### VS Code Extensions

- `anthropic.claude-code`

# Using Claude Code in devcontainers

## Requirements

This feature requires Node.js and npm to be available in the container. You need to either:

1. Use a base container image that includes Node.js, or
2. Add the Node.js feature to your devcontainer.json

## Recommended configuration

For most setups, we recommend explicitly adding both features:

```json
"features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## Using with containers that already have Node.js

If your container already has Node.js installed (for example, a container based on a Node.js image or one using nvm), you can use the Claude Code feature directly without adding the Node.js feature:

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## Using with nvm

When using with containers that have nvm pre-installed, you can use the Claude Code feature directly, and it will use the existing Node.js installation.

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/anthropics/devcontainer-features/blob/main/src/claude-code/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
