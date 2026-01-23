#!/bin/bash

source "$(dirname "$0")/../lib/test-helpers.sh"

echo "Running Feature: Zsh Plugins and Theme Installation"

# Test that Oh My Zsh is available
if curl -fsSL --head "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" >/dev/null 2>&1; then
    echo "Oh My Zsh installation script is accessible"
else
    echo "Warning: Oh My Zsh installation script may not be accessible"
fi

# Test that Powerlevel10k repository is accessible
if curl -fsSL --head "https://github.com/romkatv/powerlevel10k" >/dev/null 2>&1; then
    echo "Powerlevel10k repository is accessible"
else
    echo "Warning: Powerlevel10k repository may not be accessible"
fi

# Test that zsh-syntax-highlighting repository is accessible
if curl -fsSL --head "https://github.com/zsh-users/zsh-syntax-highlighting" >/dev/null 2>&1; then
    echo "zsh-syntax-highlighting repository is accessible"
else
    echo "Warning: zsh-syntax-highlighting repository may not be accessible"
fi

# Test that zsh-autosuggestions repository is accessible
if curl -fsSL --head "https://github.com/zsh-users/zsh-autosuggestions" >/dev/null 2>&1; then
    echo "zsh-autosuggestions repository is accessible"
else
    echo "Warning: zsh-autosuggestions repository may not be accessible"
fi

# Test that zsh-history-substring-search repository is accessible
if curl -fsSL --head "https://github.com/zsh-users/zsh-history-substring-search" >/dev/null 2>&1; then
    echo "zsh-history-substring-search repository is accessible"
else
    echo "Warning: zsh-history-substring-search repository may not be accessible"
fi

# Test that zsh-autocomplete repository is accessible
if curl -fsSL --head "https://github.com/marlonrichert/zsh-autocomplete" >/dev/null 2>&1; then
    echo "zsh-autocomplete repository is accessible"
else
    echo "Warning: zsh-autocomplete repository may not be accessible"
fi

# Test that the .zshrc file contains the expected plugins and theme
zshrc_content=$(cat src/resources/zsh/.zshrc)
assert_output_contains "Zshrc contains Powerlevel10k theme" "powerlevel10k/powerlevel10k" "$zshrc_content"
assert_output_contains "Zshrc contains zsh-syntax-highlighting plugin" "zsh-syntax-highlighting" "$zshrc_content"
assert_output_contains "Zshrc contains zsh-autosuggestions plugin" "zsh-autosuggestions" "$zshrc_content"
assert_output_contains "Zshrc contains zsh-history-substring-search plugin" "zsh-history-substring-search" "$zshrc_content"
assert_output_contains "Zshrc contains zsh-autocomplete plugin" "zsh-autocomplete" "$zshrc_content"

echo "All Zsh plugins and theme feature tests passed!"