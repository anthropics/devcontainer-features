# Claude Code CLI

This feature installs the [Claude Code CLI](https://github.com/anthropics/claude-code-cli) globally for use in development containers.

## Requirements

This feature requires Node.js and npm to be available in the container. You can:

1. Use a base container image that includes Node.js, or
2. Add the Node.js feature to your devcontainer.json, or
3. Let this feature attempt to install Node.js automatically (best-effort, works on Debian/Ubuntu, Alpine, Fedora, RHEL, and CentOS)

Note: When auto-installing Node.js, a compatible LTS version (Node.js 18.x) will be used.

## Example Usage

With Node.js feature:
```json
"features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

With Node.js base image:
```json
"image": "mcr.microsoft.com/devcontainers/javascript-node:18",
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## License

This feature is provided under the terms of the MIT license.