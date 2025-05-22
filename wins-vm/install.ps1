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

foreach ($pkg in $packages) {
    choco install $pkg -y 
}
