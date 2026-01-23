# Best Practices for .dotfiles Management with Ansible, Git, and Stow

This document outlines best practices for managing .dotfiles using Ansible, Git, and Stow. Following these guidelines ensures a clean, maintainable, and portable dotfiles setup.

## Instructions

Before performing any task, search for relevant instructions in the `.github/instructions` directory.

## General Structure

- Organize your dotfiles into logical packages (e.g., `zsh`, `vim`, `git`).
- Use a top-level directory structure that mirrors your home directory or groups related configs.
- Keep the repository in a dedicated folder (e.g., `~/.dotfiles`) and use symlinks to deploy.

## Git Best Practices

- **Version Control Everything**: Track all your dotfiles, scripts, and configurations in Git.
- **Use a Bare Repository**: For advanced setups, consider a bare Git repository in your home directory for easy management.
- **Ignore Sensitive Data**: Use `.gitignore` to exclude files containing passwords, API keys, or personal information.
- **Commit Often**: Make frequent, small commits with descriptive messages.
- **Branching**: Use branches for experimental configurations or machine-specific setups.
- **Remote Repository**: Host on GitHub, GitLab, or similar for backup and sharing.

## Stow Best Practices

- **Package Organization**: Group related dotfiles into packages (directories under your dotfiles repo).
- **Adopt Existing Files**: Use `stow --adopt` to move existing dotfiles into your managed structure.
- **Conflicts**: Be cautious with overlapping files; Stow will warn about conflicts.
- **Uninstalling**: Use `stow -D <package>` to remove symlinks before deleting packages.
- **Testing**: Always test Stow operations in a safe environment before applying to production.

## Ansible Best Practices

- **Playbook Structure**: Use a main `playbook.yml` that includes roles for different tools or groups.
- **Roles**: Create Ansible roles for each package or tool (e.g., `roles/zsh`, `roles/vim`).
- **Variables**: Use variables for user-specific or environment-specific configurations.
- **Idempotency**: Ensure playbooks are idempotent – running them multiple times should not cause issues.
- **Tags**: Use tags to run specific parts of the playbook (e.g., `ansible-playbook playbook.yml --tags zsh`).
- **Facts**: Gather facts about the system to handle different OS or distributions.
- **Templates**: Use Jinja2 templates for dynamic configuration files.
- **Vault**: Encrypt sensitive data with Ansible Vault.

## Integration Best Practices

- **Deployment Script**: Create a script that runs Stow and Ansible in sequence for full setup.
- **Backup**: Always backup existing dotfiles before deploying.
- **Testing**: Test on a virtual machine or container before applying to your main system.
- **Documentation**: Keep your README and scripts well-documented.
- **Updates**: Regularly update your dotfiles and tools to stay current.
- **Cross-Platform**: Use conditionals in Ansible to handle different operating systems.
- **Minimalism**: Only manage what you need; avoid over-complicating with unnecessary files.

## Example Workflow

1. Add new dotfiles to appropriate packages.
2. Test with Stow locally.
3. Update Ansible roles if needed.
4. Commit changes to Git.
5. Deploy on target machines using Ansible.

## Security Considerations

- Never commit sensitive information to Git.
- Use Ansible Vault for secrets.
- Be cautious with permissions on dotfiles.

## Troubleshooting

- Check Stow conflicts with `stow --conflicts <package>`.
- Use Ansible's `--check` mode for dry runs.
- Review Git status for untracked or modified files.

Following these practices will help maintain a robust and efficient dotfiles management system.