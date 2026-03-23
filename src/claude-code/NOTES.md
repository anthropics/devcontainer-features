# Using Claude Code in devcontainers

## Installation

This feature installs Claude Code using the [native installer](https://claude.ai/install.sh). No additional features or dependencies need to be added to your devcontainer configuration.

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## Alpine Linux

On Alpine-based containers, this feature automatically installs the required additional dependencies: `libgcc`, `libstdc++`, and `ripgrep`.

## Deprecation notice

The previous NPM-based installation method (`npm install -g @anthropic-ai/claude-code`) has been deprecated. This feature now uses the native installer. For more information, see the [official documentation](https://code.claude.com/docs/en/getting-started#npm-installation-deprecated).
