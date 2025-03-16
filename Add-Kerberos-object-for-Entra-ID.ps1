##########################################################################
# Add Kerberos Object for Hybrid Authentication with Micrsoft Entra ID 
##########################################################################
# version: 1.2
# last updated on: 2025-03-16 by Jonas Markström
# see readme.md for more info.
#
# This PowerShell script checks for Domain Administrator rights and Domain name 
# to then prompt for the Entra ID credentials and create/publish a new Entra ID 
# (Azure AD) Kerberos Server object in Active Directory and Entra ID. The script
# installs the required PowerShell module(s), if not already installed.
#
# For more information see: https://rb.gy/x9sz
# 
# ************************************************************************
# DISCLAIMER: This script is provided "as-is" without any warranty of
# any kind, either expressed or implied.
# ************************************************************************
#
##########################################################################


# Microsoft Entra ID Hybrid Authentication Management module is only supported in Windows PowerShell Core / 7+
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    Write-Error "Because of a Microsoft limitation you must run in Windows PowerShell (5.1)." -ErrorAction Stop
}


# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Administrator privileges required to run this script!" -ErrorAction Stop
}

# Resolve PowerShell module dependencies
    if (-not (Get-Module -ListAvailable -Name "AzureADHybridAuthenticationManagement")) {
        Write-Host "Required module not found. Installing..."
        # Set TLS 1.2 for PowerShell Gallery access
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

        try {
            Install-Module -Name "AzureADHybridAuthenticationManagement" -Force -AllowClobber
        } catch {
            Write-Error "Failed to install required module." -ErrorAction Stop
        }
    }

    # Import the module after ensuring it's installed
    try {
        Import-Module "AzureADHybridAuthenticationManagement" -ErrorAction Stop
    } catch {
        Write-Error "Failed to import required module. $_"
    }

# Get Active Directory domain name from current context
$Domain = $env:USERDNSDOMAIN
if (-not $Domain) {
    Write-Error "Failed to get domain. Please run this script on a domain-joined machine!" -ErrorAction Stop
}

# Display domain
Write-Host "Using domain: $Domain."
# Display current user
Write-Host "Using account: $env:USERNAME."

# Prompt for Entra ID User (must be member of AD and atleast Hybrid Identity Administrator in Entra ID)
$User = Read-Host "Provide the Entra ID User (UPN format, e.g., admin@contoso.com)"
if (-not $User -or $User -notmatch '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') {
    Write-Error "Invalid format. Please enter a valid Entra ID User in UPN format." -ErrorAction Stop
}

# Create the Entra ID Kerberos Server object
try {
    Write-Host "Creating Entra ID Kerberos Server object..."
    Set-AzureADKerberosServer -Domain $Domain -UserPrincipalName $User
    
    # Verify successful creation
    $kerberosServer = Get-AzureADKerberosServer -Domain $Domain -UserPrincipalName $User
    
    if ($kerberosServer) {
        Clear-Host
        Write-Host "Entra ID Kerberos Server object was created successfully." -ForegroundColor Green
        #$kerberosServer # Output the server object
    } else {
        Write-Error "Failed to create Entra ID Kerberos Server object" -ErrorAction Stop
    }
} catch {
    Write-Error "Error configuring Entra ID Kerberos Server object: $_" -ErrorAction Stop
}
