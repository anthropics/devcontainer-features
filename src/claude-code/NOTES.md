# Using Claude Code in devcontainers

## Requirements

This feature requires Node.js and npm to be available in the container. You need to either:

1. Use a base container image that includes Node.js, or
2. Add the Node.js feature to your devcontainer.json
3. Let this feature attempt to install Node.js automatically (best-effort, works on Debian/Ubuntu, Alpine, Fedora, RHEL, and CentOS)

Note: When auto-installing Node.js, a compatible LTS version (Node.js 18.x) will be used.

## Recommended configuration

For most setups, we recommend explicitly adding both features:

```json
"features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## Using with containers that already have Node.js

If your container already has Node.js installed (for example, a container based on a Node.js image or one using nvm), you can use the Claude Code feature directly without adding the Node.js feature:

```json
"features": {
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
}
```

## Using with nvm

When using with containers that have nvm pre-installed, you can use the Claude Code feature directly, and it will use the existing Node.js installation.

## Optional Network Firewall

This feature includes a network firewall script that you can optionally enable to restrict outbound traffic to only essential services (GitHub, npm registry, Anthropic API, etc.). This improves security by limiting the container's network access.

The firewall script is installed but not enabled by default. To enable the firewall, add these to your devcontainer.json:

```json
"runArgs": [
    "--cap-add=NET_ADMIN",
    "--cap-add=NET_RAW"
],
"postCreateCommand": "sudo /usr/local/bin/init-firewall.sh"
```

The firewall will be initialized when the container starts, blocking all outbound connections except to essential services. The allowed services include:

- GitHub API, Git, and Web services
- npm registry
- Anthropic API
- Sentry.io
- Statsig services

All other outbound connections will be blocked, providing an additional layer of security for your development environment.

### How the Firewall Works

The firewall uses iptables and ipset to:

1. Create a whitelist of allowed domains and IP addresses
2. Allow all established connections and responses
3. Allow outbound DNS and SSH
4. Block all other outbound connections

The script automatically resolves and adds the IP addresses for essential services to the whitelist. If you need to add additional domains to the allowed list, you can modify the firewall script at `/usr/local/bin/init-firewall.sh`.
