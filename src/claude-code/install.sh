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

# Function to install Claude Code CLI using the native installer
install_claude_code() {
    echo "Installing Claude Code CLI..."
    su - "$_REMOTE_USER" -c 'curl -fsSL https://claude.ai/install.sh | bash'

    # The native installer places the binary in ~/.local/bin (symlink to ~/.local/share/claude/).
    # Copy the resolved binary to /usr/local/bin so it is available to all users.
    REMOTE_USER_HOME=$(eval echo "~$_REMOTE_USER")
    CLAUDE_LOCAL="$REMOTE_USER_HOME/.local/bin/claude"
    if [ -e "$CLAUDE_LOCAL" ]; then
        CLAUDE_REAL="$(readlink -f "$CLAUDE_LOCAL")"
        cp "$CLAUDE_REAL" /usr/local/bin/claude
        chmod +x /usr/local/bin/claude
        echo "Claude Code CLI installed successfully!"
        /usr/local/bin/claude --version
        return 0
    else
        echo "ERROR: Claude Code CLI installation failed!"
        return 1
    fi
}

# Main script starts here
main() {
    echo "Activating feature 'claude-code'"

    # Detect package manager
    PKG_MANAGER=$(detect_package_manager)
    echo "Detected package manager: $PKG_MANAGER"

    # Ensure curl and bash are available
    MISSING_DEPS=""
    command -v curl >/dev/null || MISSING_DEPS="$MISSING_DEPS curl"
    command -v bash >/dev/null || MISSING_DEPS="$MISSING_DEPS bash"
    if [ -n "$MISSING_DEPS" ]; then
        echo "Installing missing dependencies:$MISSING_DEPS"
        install_packages "$PKG_MANAGER" $MISSING_DEPS
    fi

    # Alpine requires additional dependencies for the native installer
    if [ "$PKG_MANAGER" = "apk" ]; then
        echo "Alpine detected, installing additional dependencies..."
        install_packages apk libgcc libstdc++ ripgrep
    fi

    # Install Claude Code CLI
    install_claude_code || exit 1
}

# Execute main function
main
