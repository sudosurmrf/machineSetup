# Windows Dev Installer

This repository provides an automated PowerShell script to install common development tools on Windows that we will use in our cohort:

- Git (with Git-Bash)
- Node.js 
- PostgreSQL (psql)
- Visual Studio Code
- GitHub CLI (gh)

## Prerequisites

- Windows 10 or later
- [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) (Windows Package Manager) (make sure to have this downloaded first before proceeding)

## How to Use

** If your computer has a strict execution policy, you will need to run the following command first in Powershell **

Set-ExecutionPolicy RemoteSigned -Scope Process


1. **Clone or Download** this repository:
   ```bash
   git clone https://github.com/sudosurmrf/machineSetup.git

2. Open Powershell as Admin in the cloned or created folder.

3. Run the following script: .\Install-DevTools.ps1

4. Follow any prompts that arise and wait for installation to be complete.

5. Restart Powershell / open a new terminal afterwards to verify that all programs have been added to PATH.

6. Verifying Installations:

Git: git --version
Node.js: node --version
PostgreSQL (psql): psql --version
VS Code: code --version
GitHub CLI: gh --version