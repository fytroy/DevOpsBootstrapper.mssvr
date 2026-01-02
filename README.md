# Windows DevOps Bootstrap

## Overview
This project provides an automated PowerShell script (`setup.ps1`) to bootstrap a Windows Server or Windows workstation environment for DevOps and software development tasks. It is designed to quickly turn a fresh Cloud VM or local installation into a ready-to-code environment.

## Features
- **Automated Tool Installation**: Uses [Chocolatey](https://chocolatey.org/) to install essential development tools.
- **System Configuration**: Enables Wireless Networking and Windows Audio services, which are often disabled by default on Windows Server.
- **Environment Setup**: Configures environment variables and verifies installations.

## Included Tools
The following tools are installed automatically via Chocolatey:
- **Version Control**: Git
- **Runtimes & Languages**:
  - Node.js (LTS)
  - Python 3 (includes pip)
  - OpenJDK (Microsoft Build of OpenJDK)
- **Editors**: Visual Studio Code
- **Containerization**: Docker Desktop
- **Infrastructure as Code**: Terraform
- **Cloud CLI**: AWS CLI
- **Utilities**:
  - 7-Zip
  - Google Chrome
  - PowerShell Core (PowerShell 7)

## Prerequisites
- **Operating System**: Windows Server 2016/2019/2022 or Windows 10/11.
- **Privileges**: Administrator privileges are required to install packages and modify system settings.
- **Connectivity**: An active Internet connection is required to download packages.

## Usage

1.  **Clone or Download** this repository to your target machine.
2.  **Open PowerShell as Administrator**.
    - Right-click on the PowerShell icon and select "Run as Administrator".
3.  **Navigate** to the directory containing the script.
    ```powershell
    cd path\to\repository
    ```
4.  **Run the script**:
    ```powershell
    .\setup.ps1
    ```

## Post-Installation
- **Restart**: A system restart is recommended after running the script to finalize the Wireless LAN feature installation.
- **Audio**: If audio issues persist after enabling the Windows Audio service, ensure that specific manufacturer drivers for your hardware are installed.
- **Environment Variables**: The script attempts to refresh environment variables, but you may need to restart your PowerShell session or the machine to see all changes.

## License
This project is open source.
