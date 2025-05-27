# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Chocolatey is NOT installed." -ForegroundColor Red
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}


# List of packages to install
$packages = @(
    "vscode",
    "slack",
    "nodejs",
    "jdk8",
    "postman",
    "dbeaver",
    "docker-desktop",
    "postgresql"
)

# Install packages
foreach ($pkg in $packages) {
    choco install $pkg -y 
}

# Disable telnet
Uninstall-WindowsFeature -Name Telnet-Client

# Disable SMBv2 
Set-SmbServerConfiguration -EnableSMB2Protocol $false

# Disable PowerShell V2
Disable-WindowsOptionalFeature -FeatureName MicrosoftWindowsPowershellV2 -Online -NoRestart

# Remove Snipping Tool
Remove-WindowsCapability -Online -Name "Microsoft.Windows.SnippingTool~~~~0.0.1.0"


# Set the registry key to disable clipboard redirection
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fDisableClip" -Value 1 -Type DWord -Force

# Stop the rdpclip process to immediately disable clipboard redirection 
Stop-Process -Name "rdpclip" -ErrorAction SilentlyContinue


