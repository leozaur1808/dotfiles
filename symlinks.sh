#!/bin/bash

# Directory where your dotfiles repository is located
DOTFILES_DIR="$HOME/dotfiles"

# Function to create a symlink with backup if the original file exists
create_symlink_with_backup() {
    local source_file="$1"
    local target_file="$2"

    if [[ -f "$target_file" || -L "$target_file" ]]; then
        mv "$target_file" "${target_file}_backup"
        echo "Existing $target_file backed up as ${target_file}_backup"
    fi

    ln -sf "$source_file" "$target_file"
    echo "Symlink created for $target_file"
}

create_symlink_with_backup "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"

create_symlink_with_backup "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

create_symlink_with_backup "$DOTFILES_DIR/.hushlogin" "$HOME/.hushlogin"

create_symlink_with_backup "$DOTFILES_DIR/.curlrc" "$HOME/.curlrc"

# Add more symlinks as needed for other dotfiles

