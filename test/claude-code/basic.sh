#!/bin/bash

set -e

# Test if Claude CLI is installed
if ! command -v claude &> /dev/null; then
    echo "claude command not found"
    exit 1
fi

# Test version output 
if ! claude -v | grep -q "Claude Code"; then
    echo "claude version check failed"
    exit 1
fi

echo "Claude CLI installation test passed!"
exit 0