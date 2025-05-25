# Disable-WindowsFeatures.ps1
# Script to disable PowerShell v2, Telnet, and SMBv1 Windows features
# Run as Administrator

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator. Right-click the PowerShell icon and select 'Run as Administrator'."
    exit 1
}

Write-Host "Starting Windows Features removal..." -ForegroundColor Green

# Function to disable a Windows feature and report status
function Disable-Feature {
    param (
        [string]$FeatureName,
        [string]$DisplayName
    )
    
    Write-Host "Checking status of $DisplayName..." -ForegroundColor Yellow
    
    # Check if feature exists
    $feature = Get-WindowsOptionalFeature -Online -FeatureName $FeatureName -ErrorAction SilentlyContinue
    
    if ($null -eq $feature) {
        Write-Host "Feature $DisplayName ($FeatureName) not found on this system." -ForegroundColor Cyan
        return
    }
    
    # Check if feature is already disabled
    if ($feature.State -eq "Disabled") {
        Write-Host "$DisplayName is already disabled." -ForegroundColor Cyan
        return
    }
    
    # Disable the feature
    Write-Host "Disabling $DisplayName..." -ForegroundColor Yellow
    try {
        $result = Disable-WindowsOptionalFeature -Online -FeatureName $FeatureName -NoRestart
        if ($result.RestartNeeded) {
            Write-Host "System restart required to complete disabling $DisplayName." -ForegroundColor Red
            $global:restartNeeded = $true
        } else {
            Write-Host "$DisplayName has been disabled successfully." -ForegroundColor Green
        }
    } catch {
        Write-Host "Error disabling $DisplayName: $_" -ForegroundColor Red
    }
}

# Initialize restart flag
$global:restartNeeded = $false

# 1. Disable PowerShell v2
Disable-Feature -FeatureName "MicrosoftWindowsPowerShellV2" -DisplayName "PowerShell v2"
Disable-Feature -FeatureName "MicrosoftWindowsPowerShellV2Root" -DisplayName "PowerShell v2 Root"

# 2. Disable Telnet Client
Disable-Feature -FeatureName "TelnetClient" -DisplayName "Telnet Client"

# 3. Disable SMBv1
Disable-Feature -FeatureName "SMB1Protocol" -DisplayName "SMB v1 Protocol"
Disable-Feature -FeatureName "SMB1Protocol-Client" -DisplayName "SMB v1 Client"
Disable-Feature -FeatureName "SMB1Protocol-Server" -DisplayName "SMB v1 Server"

# Summary
Write-Host "`nSummary of disabled features:" -ForegroundColor Green
Write-Host "- PowerShell v2" -ForegroundColor White
Write-Host "- Telnet Client" -ForegroundColor White
Write-Host "- SMB v1 Protocol (Client and Server)" -ForegroundColor White

# Prompt for restart if needed
if ($global:restartNeeded) {
    Write-Host "`nA system restart is required to complete the changes." -ForegroundColor Red
    $restart = Read-Host "Do you want to restart now? (Y/N)"
    if ($restart -eq "Y" -or $restart -eq "y") {
        Write-Host "Restarting system..." -ForegroundColor Yellow
        Restart-Computer -Force
    } else {
        Write-Host "Please restart your system manually to complete the changes." -ForegroundColor Yellow
    }
} else {
    Write-Host "`nAll changes have been applied successfully. No restart required." -ForegroundColor Green
}

Write-Host "`nScript completed." -ForegroundColor Green
