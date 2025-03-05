# Dev Container Features

This repository contains [Dev Container Features](https://containers.dev/implementors/features/), including one that installs the Claude Code CLI.

## Contents

- `src/claude-code`: The Claude Code CLI feature
- `test`: Automated tests for the feature

## Usage

To use this feature in your devcontainer, add it to your `devcontainer.json` file:

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1.0": {}
}
```

## Requirements

The feature automatically depends on Node.js and will install it if not already present.

## Building and Testing

You can build and test the feature using the [dev container CLI](https://github.com/devcontainers/cli):

```bash
# Test the feature
devcontainer features test -f claude-code .

# Publish the feature
devcontainer feature publish -n anthropics/devcontainer-features .
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.