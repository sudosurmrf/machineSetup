<#
.SYNOPSIS
  Installs development tools on Windows using winget, and configures PATH for our dev environment.
** If your computer has a strict execution policy, you will need to run the following command first in Powershell **

Set-ExecutionPolicy RemoteSigned -Scope Process

.DESCRIPTION
  This script will install:
    - Git (with Git-Bash)
    - Node.js
    - PostgreSQL (psql)
    - Visual Studio Code
    - GitHub CLI (gh)
  It will also update the PATH environment variable if necessary.
#>

# Ensure script runs as Administrator (if it does not, there may be an error here, let a teacher know if this occurs)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "This script needs to be run as Administrator. Exiting."
    exit 1
}

Write-Host "Checking for winget..."
if (!(Get-Command winget.exe -ErrorAction SilentlyContinue)) {
    Write-Error "winget is not installed. Please install the Windows Package Manager and re-run this script."
    exit 1
}

# Helper function: Installs an app via winget if not already installed
function Install-AppIfMissing($wingetId, $displayName) {
    Write-Host "----------------------------------------------------"
    Write-Host "Checking installation for $displayName..."

    # Check if already installed:
    $installed = winget list --source winget | Where-Object { $_.Id -eq $wingetId }
    if ($installed) {
        Write-Host "$displayName is already installed."
    } else {
        Write-Host "Installing $displayName via winget..."
        winget install --id $wingetId --silent --accept-package-agreements --accept-source-agreements
    }
}

# 1. Git (with Git-Bash)
Install-AppIfMissing -wingetId "Git.Git" -displayName "Git"

# 2. Node.js
Install-AppIfMissing -wingetId "OpenJS.NodeJS.LTS" -displayName "Node.js (LTS)"

# 3. PostgreSQL (psql)  
Install-AppIfMissing -wingetId "PostgreSQL.PostgreSQL.17" -displayName "PostgreSQL 17 (psql)"

# 4. Visual Studio Code
Install-AppIfMissing -wingetId "Microsoft.VisualStudioCode" -displayName "Visual Studio Code"

# 5. GitHub CLI (gh)
Install-AppIfMissing -wingetId "GitHub.cli" -displayName "GitHub CLI (gh)"

# ----
# (Optional) Add PostgreSQL’s bin directory to PATH, if it exists.
# By default, winget adds most apps to PATH automatically, but if you need it:
# ----
$postgresDir = "C:\Program Files\PostgreSQL\17\bin"
if (Test-Path $postgresDir) {
    if ($env:Path -notlike "*$postgresDir*") {
        Write-Host "Adding PostgreSQL bin directory to PATH..."
        $newPath = $env:Path + ";" + $postgresDir
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "PATH updated. You may need to open a new terminal for changes to take effect."
    }
}
Write-Host "`nConfiguring VS Code to use Git Bash as the default terminal..."

# 1. The typical path for Git Bash installed via winget (hopefully its here):
$gitBashPath = "C:\Program Files\Git\bin\bash.exe"

# 2. Path to VS Code's settings.json:
$vsCodeSettingsPath = Join-Path $env:APPDATA "Code\User\settings.json"

# 3. Ensure the file exists and load it (or create a new, empty JSON if necessary)
if (!(Test-Path $vsCodeSettingsPath)) {
    Write-Host "Creating a new VS Code settings.json file at:"
    Write-Host $vsCodeSettingsPath
    New-Item -ItemType File -Path $vsCodeSettingsPath -Force | Out-Null
    $settings = @{}
} else {
    try {
        $settingsContent = Get-Content $vsCodeSettingsPath -Raw
        # checks if this file is empty or invalid JSON
        if ([string]::IsNullOrWhiteSpace($settingsContent)) {
            $settings = @{}
        } else {
            $settings = $settingsContent | ConvertFrom-Json
        }
    } catch {
        Write-Host "Error reading existing settings.json. Overwriting with new settings..."
        $settings = @{}
    }
}

# 4. Add a "Git Bash" terminal profile to terminal.integrated.profiles.windows
if (-not $settings."terminal.integrated.profiles.windows") {
    $settings."terminal.integrated.profiles.windows" = @{}
}
$settings."terminal.integrated.profiles.windows"."Git Bash" = @{
    path = $gitBashPath
    icon = "terminal-bash"
}

# 5. Set "Git Bash" as the default profile on Windows
$settings."terminal.integrated.defaultProfile.windows" = "Git Bash"

# 6. Convert back to JSON and overwrite settings.json
try {
    $updatedSettings = $settings | ConvertTo-Json -Depth 32
    Set-Content -Path $vsCodeSettingsPath -Value $updatedSettings
    Write-Host "VS Code default terminal successfully set to Git Bash."
} catch {
    Write-Host "Failed to update settings.json:"
    Write-Host $_.Exception.Message
}

Write-Host "`nAll tasks completed."
Write-Host "If any apps were installed just now, please restart PowerShell or open a new terminal."
Write-Host "Open VS Code to confirm the default terminal is set to Git Bash."

