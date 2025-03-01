#!/bin/sh
set -e

echo "Activating feature 'claude-code'"

# Check that Node.js and npm are available (should be guaranteed by dependsOn)
if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
    echo "ERROR: Node.js and npm are required but not found!"
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