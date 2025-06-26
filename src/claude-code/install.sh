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

# Function to install Claude Code CLI
install_claude_code() {
    local install_as_user="$1"
    
    if [ "$install_as_user" = "true" ]; then
        echo "Installing Claude Code CLI for current user..."
        
        # Set npm to install to user directory
        export NPM_CONFIG_PREFIX="$HOME/.local"
        mkdir -p "$HOME/.local/bin"
        
        # Install globally but to user directory
        npm install -g @anthropic-ai/claude-code
        
        # Add user bin directory to PATH
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
            echo "Added $HOME/.local/bin to PATH"
        fi
        
        # Create a script to ensure PATH is set for the user
        cat > "$HOME/.bashrc_claude" << 'EOF'
# Add user-local npm packages to PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
EOF
        
        # Source the script in common shell configs
        for config_file in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
            if [ -f "$config_file" ] && ! grep -q "source.*\.bashrc_claude" "$config_file"; then
                echo "source ~/.bashrc_claude" >> "$config_file"
                echo "Added Claude Code PATH setup to $config_file"
            fi
        done
        
    else
        echo "Installing Claude Code CLI globally..."
        npm install -g @anthropic-ai/claude-code
    fi

    # Check if claude command is available
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
    
    # Read the installAsUser option (default: false)
    local install_as_user="${INSTALLASUSER:-false}"
    echo "Install as user: $install_as_user"

    # Detect package manager
    PKG_MANAGER=$(detect_package_manager)
    echo "Detected package manager: $PKG_MANAGER"

    # Try to install Node.js if it's not available
    if ! command -v node >/dev/null || ! command -v npm >/dev/null; then
        echo "Node.js or npm not found, attempting to install automatically..."
        install_nodejs "$PKG_MANAGER" || print_nodejs_requirement
    fi

    # Install Claude Code CLI
    install_claude_code "$install_as_user" || exit 1
}

# Execute main function
main