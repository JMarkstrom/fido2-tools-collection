##########################################################################
# Add Kerberos object from on-premise AD to Azure AD           
##########################################################################
# version: 1.1
# last updated on: 2023-03-31 by Jonas Markström
# see readme.md for more info.
#
# This PowerShell script is designed to establish an Azure AD Kerberos Server 
# object within your on-premise AD, enabling seamless FIDO2 (SSO) access to 
# on-premise resources like network shares. It's important to note that this 
# isn't mandatory for FIDO2 security key sign-in, but it does broaden the scope 
# of security key utilization beyond PC login.
#
# For more information see: https://rb.gy/x9sz
# 
# ************************************************************************
# DISCLAIMER: This script is provided "as-is" without any warranty of
# any kind, either expressed or implied.
# ************************************************************************
#
##########################################################################

# Set the directory path where the AzureAdKerberos module is located
$moduleDir = "C:\Program Files\Microsoft Azure Active Directory Connect\AzureADKerberos"
# Change the current directory to the module directory
Set-Location $moduleDir
# Import the AzureAdKerberos module from the module directory
Import-Module ".\AzureAdKerberos.psd1"

# Prompt the user to enter the on-premises Active Directory domain
$domain = Read-Host "Enter the name of your on-premises Active Directory domain (e.g. contoso.corp.com):"

# Enter in the Azure Active Directory global administrator username and password.
$cloudCred = Get-Credential -Message "Enter the Azure AD global administrator credentials:"

# Enter in the domain administrator username and password.
$domainCred = Get-Credential -Message "Enter the domain administrator credentials:"

# Create the new Azure AD Kerberos Server object in Active Directory
# and then publish it to Azure Active Directory.
Set-AzureADKerberosServer -Domain $domain -CloudCredential $cloudCred -DomainCredential $domainCred

# Verify that the new Azure AD Kerberos Server object was created successfully
if (Get-AzureADKerberosServer -Domain $domain -CloudCredential $cloudCred -DomainCredential $domainCred) {
    Write-Host "Azure AD Kerberos Server object was created successfully."
} else {
    Write-Host "Failed to create Azure AD Kerberos Server object."
}


