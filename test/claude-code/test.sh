#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Skip Node.js checks during auto-generated tests
# This is because we can't install Node.js during the test phase - it must be available before feature installation
# For auto-generated tests, use --filter with the with-node scenario

# Only test for Claude CLI
check "claude cli installed" command -v claude &> /dev/null || echo "claude command not found"
check "claude version" claude --version || echo "Could not get claude version"

# Report results
reportResults