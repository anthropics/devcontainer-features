#!/bin/bash

set -e

# Validate the auto-install path installed Node.js 18 from NodeSource.
if ! node --version | grep -q "^v18\."; then
    echo "expected Node.js 18.x from auto-install path"
    exit 1
fi

if [ ! -f /etc/apt/sources.list.d/nodesource.list ]; then
    echo "expected NodeSource apt source list to exist"
    exit 1
fi

echo "Auto-install Node.js scenario checks passed!"
exit 0
