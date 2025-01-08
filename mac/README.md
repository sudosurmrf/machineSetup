# Mac Dev Installer

A simple script to automate installation of developer tools on macOS:

- [Homebrew](https://brew.sh/) (if not already installed)
- Git
- Node.js
- PostgreSQL
- GitHub CLI
- Visual Studio Code (via Homebrew Cask)
- Sets Bash as default integrated terminal in VS Code (optional)

## How to Use

1. **Clone or download** this repository:
   ```bash
   git clone https://github.com/sudosurmrf/machineSetup.git

2. After saving and downloading the files, path to the containing mac folder and run this command:

chmod +x Install-DevTools_mac.sh

3. After the script becomes an Executable, run: 

./Install-DevTools_mac.sh

4. Enter your Password when prompted by the computer (for installing software).


5. Wait for it to finish. Once done:
 - You’ll have Git, Node.js, PostgreSQL, GitHub CLI, and VS Code installed.
 - VS Code’s default terminal will be set to Bash.

6. Open VS Code and confirm the integrated terminal is Bash.


### Troubleshooting ###

- Path Issues: Open a new terminal session or run source ~/.zshrc (or ~/.bash_profile) to ensure your PATH updates.

- VS Code Settings Location: The script modifies ~/Library/Application Support/Code/User/settings.json. If you have a custom location or use VS Code Insiders, adjust the path accordingly.

- Homebrew Already Installed: The script simply updates Homebrew if it’s already on your system.

- Permissions: If you run into permission issues, ensure your user has the appropriate rights (and that /usr/local and related directories are writable if you’re on Intel-based macs; /opt/homebrew for Apple Silicon)