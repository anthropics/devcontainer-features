# Using Claude Code Mounts in devcontainers

## Requirements

This feature requires:

1. The Claude Code CLI to be installed (use the `claude-code` feature first)
2. Claude Code configuration files to exist on your host machine at `~/.claude/`
3. HOME environment variable to be properly set on the host system

Note: On Windows, ensure the HOME environment variable is set (e.g. using "Edit user environment variables" in the system settings).

## Recommended configuration

For most setups, we recommend using this feature together with the main Claude Code feature:

```json
"features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code-mounts:1": {}
}
```

## What gets mounted

This feature mounts the following Claude Code configuration files and directories from your host machine:

- `~/.claude/CLAUDE.md` - Global project instructions (read-only)
- `~/.claude/settings.json` - Claude Code configuration (read-only)
- `~/.claude/agents/` - Custom agent configurations (read-only)
- `~/.claude/commands/` - Custom command definitions (read-only)
- `~/.claude/hooks/` - Event-driven shell commands (read-only)

All mounts are read-only to prevent accidental modification from within the container.

## Installation order

This feature uses `installsAfter` to ensure it runs after:
1. Node.js feature (if used)
2. Claude Code feature

This ensures the Claude Code CLI is available before mounting configuration files.

## Troubleshooting

### Errors when building the dev container

- Ensure that mounted files and directories exist on host machine
- Check that the HOME environment variable is set correctly
- Ensure the devcontainer has been rebuilt after adding this feature

### Permission issues

- All mounts are read-only by design
- If you need to modify configuration, do so on the host machine and restart the container