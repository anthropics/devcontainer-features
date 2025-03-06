# Claude Code CLI

This feature installs the [Claude Code CLI](https://github.com/anthropics/claude-code-cli) globally for use in development containers.

## Requirements

This feature requires Node.js and npm to be available in the container. You need to either:
1. Use a base container image that includes Node.js, or
2. Add the Node.js feature to your devcontainer.json

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