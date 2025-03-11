#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Verify firewall script exists and is executable
if [ ! -f /usr/local/bin/init-firewall.sh ]; then
    echo "ERROR: Firewall script not found at /usr/local/bin/init-firewall.sh"
    check "firewall script exists" false
    reportResults
    exit 1
fi

if [ ! -x /usr/local/bin/init-firewall.sh ]; then
    echo "ERROR: Firewall script is not executable"
    check "firewall script is executable" false
    reportResults
    exit 1
fi

# Check if we can reach GitHub API (should be allowed)
if curl --connect-timeout 5 https://api.github.com/zen >/dev/null 2>&1; then
    check "can reach GitHub API" true
else
    echo "ERROR: Cannot reach GitHub API, which should be allowed"
    check "can reach GitHub API" false
fi

# Check if we can reach example.com (should be blocked)
if curl --connect-timeout 5 https://example.com >/dev/null 2>&1; then
    echo "ERROR: Can reach example.com, which should be blocked"
    check "example.com is blocked" false
else
    check "example.com is blocked" true
fi

# Report results
reportResults
