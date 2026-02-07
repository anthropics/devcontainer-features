#!/bin/sh
# POSIX-compliant test script (no bash required)
# Does not use dev-container-features-test-lib which requires bash

set -e

FAILED=""

check() {
    LABEL="$1"
    shift
    printf '\n\n'
    printf "🔄 Testing '%s'\n" "$LABEL"
    printf '\033[37m\n'
    if "$@"; then
        printf '\n\n'
        printf "✅  Passed '%s'!\n" "$LABEL"
        return 0
    else
        printf '\n\n'
        printf "❌ %s check failed.\n" "$LABEL" >&2
        FAILED="$FAILED $LABEL"
        return 1
    fi
}

reportResults() {
    printf '\n\n'
    if [ -n "$FAILED" ]; then
        printf "💥  Failed tests:%s\n" "$FAILED" >&2
        exit 1
    else
        printf 'Test Passed!\n'
        exit 0
    fi
}

# Definition specific tests
check "node version" node --version
check "npm version" npm --version
check "claude cli installed" command -v claude
check "claude version" claude --version
check "claude auto-update" npm install -g @anthropic-ai/claude-code

# Report result
reportResults
