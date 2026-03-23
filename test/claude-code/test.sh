#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "claude cli installed" command -v claude
check "claude version" claude --version

# Report results
reportResults
