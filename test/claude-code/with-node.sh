#!/bin/bash

set -e

# Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "node already installed" node --version
check "npm already installed" npm --version
check "claude cli installed" command -v claude
check "claude version" claude --version

# Report results
reportResults