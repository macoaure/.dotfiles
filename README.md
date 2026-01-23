# .dotfiles Management

This project aims to manage custom .dotfiles using Ansible, Git, and Stow.

## Overview

Dotfiles are configuration files for various tools and applications, typically hidden files starting with a dot (e.g., `.bashrc`, `.vimrc`). This repository provides a structured way to organize, version control, and deploy these files across different machines using:

- **Git**: For version control and tracking changes.
- **Stow**: For managing symlinks to dotfiles without cluttering the home directory.
- **Ansible**: For automating the setup and deployment process.

## Packages

### Nano
- `src/resources/nano/.nanorc`: Nano text editor configuration with syntax highlighting, line numbers, and custom key bindings

### Git
- `src/resources/git/.gitconfig`: Git configuration with user settings, aliases, and color schemes
- `src/resources/git/.gitignore_global`: Global gitignore file for common files to ignore

### Zsh
- `src/resources/zsh/.zshrc`: Zsh shell configuration with Oh My Zsh integration
- `src/resources/zsh/.zsh_aliases`: Custom aliases for common commands with automatic distribution detection for package managers (apt, dnf, pacman, zypper, etc.)
- `src/resources/zsh/.zsh_functions`: Custom shell functions for productivity

### Oh My Zsh
- `src/resources/oh-my-zsh/custom/themes/custom.zsh-theme`: Custom Oh My Zsh theme

### Ghostty
- `src/resources/ghostty/.config/ghostty/config`: Ghostty terminal emulator configuration with Zsh as default shell, custom font, and keybindings

## Installation

Run the following command to install your dotfiles:

```bash
curl -sSL https://raw.githubusercontent.com/yourusername/.dotfiles/main/bin/install.sh | bash
```

This will automatically clone the repository, install prerequisites (Git, Ansible, Stow), and set up your environment.

### Manual Setup

1. Install the packages using Ansible:
   ```bash
   ansible-playbook src/setup.yml
   ```

   **Note**: If sudo requires a password on your system, use:
   ```bash
   ansible-playbook src/setup.yml --ask-become-pass
   ```

   Or set up passwordless sudo for your user:
   ```bash
   sudo visudo
   # Add this line (replace 'username' with your actual username):
   # username ALL=(ALL) NOPASSWD: ALL
   ```

2. Stow the configuration files:
   ```bash
   cd src/resources
   stow nano git zsh oh-my-zsh
   ```

### Development Testing

To test the dotfiles setup in a Docker container with interactive access:

```bash
./dev/shell.sh
```

This script will:
- Run a clean Ubuntu container
- Install all required packages (Ansible, Git, Stow, etc.)
- Execute the Ansible playbook
- **Drop you into an interactive bash shell** for testing and inspection
- Type `exit` to leave the container

### Usage

- Add your dotfiles to the appropriate directories.
- Use Stow to manage symlinks:
  ```bash
  stow <package>
  ```
- Commit and push changes to Git for version control.

## Contributing

Feel free to contribute by adding your own dotfiles or improving the automation scripts.

## License

This project is licensed under the MIT License.