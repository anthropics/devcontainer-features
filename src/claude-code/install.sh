#!/bin/sh
set -eu

echo "Activating feature 'claude-code'"

# Try to install Node.js if it's not available and we're in a supported environment
if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
    echo "Node.js or npm not found, attempting to install automatically..."
    
    # Only attempt installation in certain environments
    if command -v apt-get >/dev/null; then
        # Debian/Ubuntu - most likely to work
        apt-get update && apt-get install -y nodejs npm && echo "Successfully installed Node.js and npm"
    elif command -v apk >/dev/null; then
        # Alpine
        apk add --no-cache nodejs npm && echo "Successfully installed Node.js and npm"
    elif command -v dnf >/dev/null; then
        # Fedora/RHEL
        dnf install -y nodejs npm && echo "Successfully installed Node.js and npm"
    elif command -v yum >/dev/null; then
        # CentOS/RHEL
        yum install -y nodejs npm && echo "Successfully installed Node.js and npm"
    else
        # If we can't install Node.js, show the error message but continue
        echo "ERROR: Node.js and npm are required but not found!"
        echo "Please add the Node.js feature to your devcontainer.json:"
        echo ""
        echo "  \"features\": {"
        echo "    \"ghcr.io/devcontainers/features/node:1\": {},"
        echo "    \"ghcr.io/anthropics/devcontainer-features/claude-code:1\": {}"
        echo "  }"
        echo ""
        echo "Continuing anyway for testing purposes..."
    fi
fi

# Verify Node.js is now available
if command -v node >/dev/null && command -v npm >/dev/null; then
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
else
    echo "ERROR: Could not install or find Node.js and npm. Claude Code CLI installation failed."
    # Exit with error
    exit 1
fi
