#!/usr/bin/env bash
#
# Installs developer tools on macOS using Homebrew for our Fullstack Cohort
# and configures VS Code's default integrated terminal to Bash so we have consistent cli commands across OS.

set -e  # Exit immediately if a command exits with a non-zero status

########################################
# 1. Ensure Homebrew is installed
########################################
if ! command -v brew &> /dev/null
then
  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "Homebrew installed successfully."
else
  echo "Homebrew is already installed."
fi

echo "Updating Homebrew..."
brew update

########################################
# 2. Install Tools via Brew
########################################
echo "Installing Git..."
brew install git

echo "Installing Node.js..."
brew install node

echo "Installing PostgreSQL..."
brew install postgresql

echo "Installing GitHub CLI..."
brew install gh

echo "Installing Visual Studio Code..."
brew install --cask visual-studio-code

########################################
# 3. (Optional) Configure VS Code to use Bash as default terminal
########################################
echo "Installing 'jq' for JSON manipulation (if not already present)..."
brew install jq

CODE_SETTINGS_PATH="$HOME/Library/Application Support/Code/User/settings.json"

echo "Configuring VS Code to use Bash as the default integrated terminal..."
if [[ ! -f "$CODE_SETTINGS_PATH" ]]; then
  echo "{}" > "$CODE_SETTINGS_PATH"
  echo "Created a new VS Code settings.json at: $CODE_SETTINGS_PATH"
fi

# Safely load existing settings.json or default to {}
EXISTING_SETTINGS=$(jq '.' "$CODE_SETTINGS_PATH" 2>/dev/null || echo "{}")

# Add a "bash" profile to "terminal.integrated.profiles.osx" and set it as default
UPDATED_SETTINGS=$(echo "$EXISTING_SETTINGS" | jq '
  .["terminal.integrated.profiles.osx"] += {
    "bash": {
      "path": "/bin/bash",
      "icon": "terminal-bash"
    }
  }
  | .["terminal.integrated.defaultProfile.osx"] = "bash"
')

echo "$UPDATED_SETTINGS" > "$CODE_SETTINGS_PATH"

echo "VS Code default terminal set to Bash. (You can change it to zsh or another shell if desired.)"

########################################
# 4. Post-install Instructions
########################################
echo ""
echo "All tasks completed!"
echo " - Git, Node.js, PostgreSQL, GitHub CLI, and VS Code are installed."
echo " - VS Code is configured to use Bash as the default integrated terminal."
echo ""
echo "Next Steps:"
echo "1) You may want to open a new terminal session so any PATH changes take effect."
echo "2) Launch VS Code and verify the default terminal is Bash."
