#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "node version" node --version
check "npm version" npm --version
check "claude cli installed" command -v claude
check "claude version" claude --version

# Check if firewall script exists when enableFirewall is true
if [ "${ENABLE_FIREWALL}" = "true" ]; then
    check "firewall script exists" test -f /usr/local/bin/init-firewall.sh
    check "firewall script is executable" test -x /usr/local/bin/init-firewall.sh
fi

# Report results
reportResults