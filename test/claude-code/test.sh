#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# First check if Node.js is present - if not, try to install it for the test
if ! command -v node &> /dev/null; then
    echo "Node.js not found, installing for test..."
    
    # Install Node.js - adapt as needed for the base image
    if command -v apt-get &> /dev/null; then
        # Debian/Ubuntu
        apt-get update && apt-get install -y nodejs npm
    elif command -v apk &> /dev/null; then
        # Alpine
        apk add --no-cache nodejs npm
    elif command -v dnf &> /dev/null; then
        # Fedora/RHEL
        dnf install -y nodejs npm
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL
        yum install -y nodejs npm
    fi
    
    check "node installed for test" node --version || true
    check "npm installed for test" npm --version || true
else
    # Node was already available
    check "node available" node --version
    check "npm available" npm --version
fi

# Feature-specific tests
check "claude cli installed" command -v claude
check "claude version" claude --version

# Report results
reportResults