#!/bin/sh
set -eu

# Function to detect the package manager and OS type
detect_package_manager() {
    for pm in apt-get apk dnf yum; do
        if command -v $pm >/dev/null; then
            case $pm in
                apt-get) echo "apt" ;;
                *) echo "$pm" ;;
            esac
            return 0
        fi
    done
    echo "unknown"
    return 1
}

# Function to install packages using the appropriate package manager
install_packages() {
    local pkg_manager="$1"
    shift
    local packages="$@"
    
    case "$pkg_manager" in
        apt)
            apt-get update
            apt-get install -y $packages
            ;;
        apk)
            apk add --no-cache $packages
            ;;
        dnf|yum)
            $pkg_manager install -y $packages
            ;;
        *)
            echo "WARNING: Unsupported package manager. Cannot install packages: $packages"
            return 1
            ;;
    esac
    
    return 0
}

# Function to install Node.js
install_nodejs() {
    local pkg_manager="$1"
    
    echo "Installing Node.js using $pkg_manager..."
    
    case "$pkg_manager" in
        apt)
            # Debian/Ubuntu - install more recent Node.js LTS
            install_packages apt "ca-certificates curl gnupg"
            mkdir -p /etc/apt/keyrings
            curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
            echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
            apt-get update
            apt-get install -y nodejs
            ;;
        apk)
            # Alpine
            install_packages apk "nodejs npm"
            ;;
        dnf)
            # Fedora/RHEL
            install_packages dnf "nodejs npm"
            ;;
        yum)
            # CentOS/RHEL
            curl -sL https://rpm.nodesource.com/setup_18.x | bash -
            yum install -y nodejs
            ;;
        *)
            echo "ERROR: Unsupported package manager for Node.js installation"
            return 1
            ;;
    esac
    
    # Verify installation
    if command -v node >/dev/null && command -v npm >/dev/null; then
        echo "Successfully installed Node.js and npm"
        return 0
    else
        echo "Failed to install Node.js and npm"
        return 1
    fi
}

# Map of package manager to required firewall packages
get_firewall_packages() {
    local pkg_manager="$1"
    
    case "$pkg_manager" in
        apt) echo "iptables ipset dnsutils jq curl" ;;
        apk) echo "iptables ipset bind-tools jq curl" ;;
        dnf|yum) echo "iptables ipset bind-utils jq curl" ;;
        *) echo "" ;;
    esac
}

# Function to install firewall packages
install_firewall_packages() {
    local pkg_manager="$1"
    local packages=$(get_firewall_packages "$pkg_manager")
    
    if [ -z "$packages" ]; then
        echo "WARNING: Could not determine firewall packages for this system type"
        return 1
    fi
    
    echo "Installing firewall packages: $packages"
    install_packages "$pkg_manager" $packages
}

# Function to set up firewall script
setup_firewall_script() {
    local script_path="/usr/local/bin/init-firewall.sh"
    
    echo "Setting up firewall initialization script..."
    
    # Create destination directory and copy the script
    mkdir -p /usr/local/bin
    cp "$(dirname "$0")/init-firewall.sh" "$script_path"
    chmod +x "$script_path"
    
    cat <<EOF

Optional network firewall script installed at $script_path

To enable the firewall, add these to your devcontainer.json:

  "runArgs": [
    "--cap-add=NET_ADMIN",
    "--cap-add=NET_RAW"
  ],
  "postCreateCommand": "sudo $script_path"

The firewall restricts outbound connections to only essential services
like GitHub, npm registry, and the Anthropic API.

EOF
}

# Function to install Claude Code CLI
install_claude_code() {
    echo "Installing Claude Code CLI..."
    npm install -g @anthropic-ai/claude-code

    if command -v claude >/dev/null; then
        echo "Claude Code CLI installed successfully!"
        claude --version
        return 0
    else
        echo "ERROR: Claude Code CLI installation failed!"
        return 1
    fi
}

# Print error message about requiring Node.js feature
print_nodejs_requirement() {
    cat <<EOF

ERROR: Node.js and npm are required but could not be installed!
Please add the Node.js feature to your devcontainer.json:

  "features": {
    "ghcr.io/devcontainers/features/node:1": {},
    "ghcr.io/anthropics/devcontainer-features/claude-code:1": {}
  }

EOF
    exit 1
}

# Main script starts here
main() {
    echo "Activating feature 'claude-code'"

    # Detect package manager
    PKG_MANAGER=$(detect_package_manager)
    echo "Detected package manager: $PKG_MANAGER"

    # Install firewall packages (always install but don't activate)
    echo "Installing optional firewall packages..."
    install_firewall_packages "$PKG_MANAGER" || echo "Firewall package installation failed, but continuing..."

    # Try to install Node.js if it's not available
    if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
        echo "Node.js or npm not found, attempting to install automatically..."
        install_nodejs "$PKG_MANAGER" || print_nodejs_requirement
    fi

    # Install Claude Code CLI
    install_claude_code || exit 1

    # Always set up the firewall script, but don't execute it
    setup_firewall_script
}

# Execute main function
main