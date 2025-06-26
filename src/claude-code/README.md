
# Claude Code CLI (claude-code)

Installs the Claude Code CLI globally

## Example Usage

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

### Installing as a user (recommended for non-root containers)

If you run your devcontainer as a non-root user (e.g., `vscode` user), use the `installAsUser` option to prevent permission issues with auto-updates:

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {
        "installAsUser": true
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installAsUser | Install Claude Code locally for the current user instead of globally. This prevents permission issues with auto-updates when running as a non-root user. | boolean | false |


## Customizations

### VS Code Extensions

- `anthropic.claude-code`

# Using Claude Code in devcontainers

## Requirements

This feature requires Node.js and npm to be available in the container. You need to either:

1. Use a base container image that includes Node.js, or
2. Add the Node.js feature to your devcontainer.json
3. Let this feature attempt to install Node.js automatically (best-effort, works on Debian/Ubuntu, Alpine, Fedora, RHEL, and CentOS)

Note: When auto-installing Node.js, a compatible LTS version (Node.js 18.x) will be used.

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

## User Installation vs Global Installation

### Global Installation (default)
- Installs Claude Code system-wide
- Requires root permissions for updates
- May cause permission issues when running as non-root user

### User Installation (`installAsUser: true`)
- Installs Claude Code to `~/.local/bin`
- Allows updates without root permissions
- Recommended when running devcontainers as non-root users
- Automatically configures PATH in shell profiles



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/anthropics/devcontainer-features/blob/main/src/claude-code/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
