#!/bin/sh
set -eu

echo "Activating feature 'claude-code-mounts'"

mkdir -p $_REMOTE_USER_HOME/.claude 
chown $_REMOTE_USER:$_REMOTE_USER $_REMOTE_USER_HOME/.claude
