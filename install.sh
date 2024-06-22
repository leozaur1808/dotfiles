#!/bin/bash

# Function to check if the latest Bash is installed
is_latest_bash_installed() {
    local latest_bash_path="$(brew --prefix)/bin/bash"
    [[ -x "$latest_bash_path" && "$($latest_bash_path --version | head -n1)" == *"version 5."* ]]
}

# Function to install the latest Bash and set it as the default shell
install_latest_bash() {
    brew install bash
    local new_bash_path="$(brew --prefix)/bin/bash"
    
    # Add the new Bash to the list of allowed shells
    if ! grep -Fxq "$new_bash_path" /etc/shells; then
        echo "$new_bash_path" | sudo tee -a /etc/shells
    fi
    
    # Change the default shell to the new Bash
    chsh -s "$new_bash_path"
}

# Function to check if a package is installed using brew
is_brew_package_installed() {
    brew list --formula | grep -Fxq "$1"
}

# Function to check if a package is installed using apt
is_apt_package_installed() {
    dpkg -l | grep -E "^ii\s+$1\s" &> /dev/null
}

# Check if the script is running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Homebrew (if not installed)
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install the latest Bash if not already installed
    if ! is_latest_bash_installed; then
        install_latest_bash
    else
        echo "Latest Bash is already installed."
    fi

    # List of packages to install
    BREW_PACKAGES=("git" "node")

    # Install each package if not already installed
    for package in "${BREW_PACKAGES[@]}"; do
        if ! is_brew_package_installed "$package"; then
            brew install "$package"
        else
            echo "Package $package is already installed."
        fi
    done

elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Assume Debian/Ubuntu for simplicity
    sudo apt update

    # List of packages to install
    APT_PACKAGES=("git" "curl" "node")

    # Install each package if not already installed
    for package in "${APT_PACKAGES[@]}"; do
        if ! is_apt_package_installed "$package"; then
            sudo apt install -y "$package"
        else
            echo "Package $package is already installed."
        fi
    done

else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi



