#!/bin/sh
set -eu

echo "Activating feature 'claude-code'"

# Try to install Node.js if it's not available and we're in a supported environment
if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
    echo "Node.js or npm not found, attempting to install automatically..."
    
    # Only attempt installation in certain environments
    if command -v apt-get >/dev/null; then
        # Debian/Ubuntu - install more recent Node.js LTS
        apt-get update
        apt-get install -y ca-certificates curl gnupg
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
        apt-get update
        apt-get install -y nodejs && echo "Successfully installed Node.js and npm"
    elif command -v apk >/dev/null; then
        # Alpine
        apk add --no-cache nodejs npm && echo "Successfully installed Node.js and npm"
    elif command -v dnf >/dev/null; then
        # Fedora/RHEL
        dnf install -y nodejs npm && echo "Successfully installed Node.js and npm"
    elif command -v yum >/dev/null; then
        # CentOS/RHEL
        curl -sL https://rpm.nodesource.com/setup_18.x | bash -
        yum install -y nodejs && echo "Successfully installed Node.js and npm"
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
        exit 1
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
