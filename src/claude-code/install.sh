#!/bin/sh
set -eu

echo "Activating feature 'claude-code'"

# Check if Node.js and npm are available
if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
    echo "ERROR: Node.js and npm are required but not found!"
    echo "Please add the Node.js feature to your devcontainer.json:"
    echo ""
    echo "  \"features\": {"
    echo "    \"ghcr.io/devcontainers/features/node:1\": {},"
    echo "    \"ghcr.io/anthropics/devcontainer-features/claude-code:1\": {}"
    echo "  }"
    echo ""
    exit 1
fi

# Install the Claude Code CLI
echo "Installing Claude Code CLI..."
npm install -g @anthropic-ai/claude-code

# Verify installation
if command -v claude >/dev/null; then
    echo "Claude Code CLI installed successfully!"
    claude --version
else
    echo "ERROR: Claude Code CLI installation failed!"
    exit 1
fi
