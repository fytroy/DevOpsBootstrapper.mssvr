<#
.SYNOPSIS
    Automated DevOps Bootstrap for Windows Server
.DESCRIPTION
    Installs essential dev tools, enables WLAN/Audio, and configures environment.
    Designed for fresh Cloud VMs or Local setups.
.NOTES
    Run this script as Administrator.
#>

# 1. Setup Logging and Error Handling
$ErrorActionPreference = "Stop"
function Log-Message {
    param([string]$Message)
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor Cyan
}

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator!"
    Break
}

Log-Message "Starting Windows DevOps Bootstrap..."

# 2. Install Chocolatey (Package Manager)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Log-Message "Chocolatey not found. Installing..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    
    # Reload environment variables so we can use 'choco' immediately
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
} else {
    Log-Message "Chocolatey is already installed."
}

# 3. Enable Windows Features (WLAN & Audio)
# Windows Server disables these by default.
Log-Message "Configuring Windows Features..."

# Enable Wireless LAN Service
try {
    $wlan = Get-WindowsFeature -Name Wireless-Networking
    if ($wlan.Installed -eq $false) {
        Log-Message "Enabling Wireless Networking..."
        Install-WindowsFeature -Name Wireless-Networking
        Log-Message "NOTE: A restart may be required for WLAN to become active."
    } else {
        Log-Message "Wireless Networking is already enabled."
    }
} catch {
    Log-Message "Skipping WLAN check (Feature not present on this edition)."
}

# Enable Audio Service (Windows Audio)
Log-Message "Enabling Windows Audio Service..."
Set-Service -Name Audiosrv -StartupType Automatic
Start-Service -Name Audiosrv -ErrorAction SilentlyContinue

# 4. Define Tool List
# Format: "PackageName"
$packages = @(
    "git",
    "nodejs-lts",       # Node.js LTS
    "python3",          # Includes pip
    "openjdk",          # Java (Microsoft build of OpenJDK)
    "vscode",           # Visual Studio Code
    "docker-desktop",   # Docker
    "terraform",        # Infrastructure as Code
    "awscli",           # AWS Command Line
    "7zip",             # Archive tool
    "googlechrome",     # Browser (Optional, strictly useful for testing)
    "powershell-core"   # PowerShell 7 (Modern PS)
)

# 5. Install Tools
Log-Message "Beginning software installation via Chocolatey..."

foreach ($pkg in $packages) {
    Log-Message "Installing $pkg..."
    choco install $pkg -y --no-progress
}

# 6. Post-Install Configurations

# Refresh Environment Variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Verify Installations
Log-Message "--- Verification ---"
Get-Command git -ErrorAction SilentlyContinue | Select-Object Name, Source
Get-Command node -ErrorAction SilentlyContinue | Select-Object Name, Source
Get-Command python -ErrorAction SilentlyContinue | Select-Object Name, Source
Get-Command java -ErrorAction SilentlyContinue | Select-Object Name, Source

Log-Message "Installation Complete! A restart is recommended to finalize the Wireless LAN feature."
Log-Message "If sound is still not working, please install the specific manufacturer drivers for your hardware."
