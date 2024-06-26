#!/bin/bash

# Source the install script
source ./install.sh

# Function to check if Oh My Bash is installed
is_oh_my_bash_installed() {
    [[ -d "$HOME/.oh-my-bash" ]]
}

# Function to install Oh My Bash
install_oh_my_bash() {
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
}

# Install Oh My Bash if not installed
if ! is_oh_my_bash_installed; then
    install_oh_my_bash
    if [ $? -ne 0 ]; then
        echo "Oh My Bash installation failed!"
        exit 1
    fi
else
    echo "Oh My Bash is already installed."
fi

# Source the symlinks script
source ./symlinks.sh

# Create .bash_profile if it doesn't exist
BASH_PROFILE="$HOME/.bash_profile"
if [[ ! -f "$BASH_PROFILE" ]]; then
    touch "$BASH_PROFILE"
    echo ".bash_profile created."
fi

# Append to .bash_profile to source .bashrc if not already done
BASHRC_SNIPPET="if [ -f \$HOME/.bashrc ]; then . \$HOME/.bashrc; fi"

# Check if the snippet is already present in .bash_profile
if ! grep -Fxq "$BASHRC_SNIPPET" "$BASH_PROFILE"; then
    echo "" >> "$BASH_PROFILE"
    echo "# Source .bashrc" >> "$BASH_PROFILE"
    echo "$BASHRC_SNIPPET" >> "$BASH_PROFILE"
    echo ".bashrc source snippet added to $BASH_PROFILE"
else
    echo ".bashrc source snippet already present in $BASH_PROFILE"
fi

# Create .ssh directory and store public ssh key there to sign commits locally
mkdir -p "$HOME/.ssh"
curl -fsSL "https://github.com/leozaur1808.keys" > $HOME/.ssh/public_key.pub
echo "Created .ssh and stored public ssh key there"

# Check if .globalenv directory already exists
if [ ! -d "$HOME/.globalenv" ]; then
    # Create .globalenv directory as Python virtual environment
    python3 -m venv "$HOME/.globalenv"
fi

# Activate .globalenv virtual environment
source "$HOME/.globalenv/bin/activate"

echo "Created python .globalenv"

source $HOME/.bash_profile

echo "Setup completed successfully."