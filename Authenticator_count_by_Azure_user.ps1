##########################################################################
# List authentication methods count by Azure user                       
##########################################################################
# version: 1.0
# last updated on: 2022-01-16 by Jonas Markström
# see readme.md for more info.
#
# NOTE: This script connects to the Microsoft Graph API and retrieves 
# information about the authentication methods used by all users in a tenant. 
# It then counts the number of each type of method and outputs the results.
# For this script to work you must install the Microsoft Graph PowerShell module. 
#
# LIMITATIONS/ KNOWN ISSUES: 
# 1. Counting the Microsoft Authenticator application using
#    'microsoftAuthenticatorAuthenticationMethod' does not currently work.
#    Instead the 'softwareOathAuthenticationMethod' is used. Note however that
#    this method will include 3rd party authenticator apps.
# 
# ************************************************************************
# DISCLAIMER: This script is provided "as-is" without any warranty of
# any kind, either expressed or implied.
# ************************************************************************
#
##########################################################################

# Connect to Microsoft Graph API
Connect-Graph -Scopes "UserAuthenticationMethod.Read.All", "User.Read.All"

# Trow an error if the user does not have requisite permissions or does not consent to requested scopes
if ($null -eq $(Get-MgContext)) {
    Throw "Authentication and/or consent needed! Make sure you approve requested scopes! "
}

Try {
    # Select the Beta profile
    Select-MgProfile -Name Beta 

    # Get all users in the tenant
    $AzureUsers = Get-mguser -all

    # Create an array to store the information for each user
    $AuthInfo = [System.Collections.ArrayList]::new()

    # Iterate through each user
    ForEach ($user in $AzureUsers) {

        # Initialize count variables
        $UserAuthMethod = $null
        $UserAuthMethod = Get-MgUserAuthenticationMethod -UserId "$($user.id)"
        $phoneCount = 0
        $softwareOathMethodsCount = 0
        $temporaryAccessPassMethodsCount = 0
        #$MicrosoftAuthenticatorCount = 0
        $EmailCount = 0
        $HelloForBusinessCount = 0
        $FIDO2Count = 0
        $PasswordCount = 0

        # List active authentication methods for each user and count them by type
        ForEach ($method in $UserAuthMethod) {
            if ($method.additionalproperties.values -match "#microsoft.graph.phoneAuthenticationMethod") { $phoneCount += 1 }
            if ($method.additionalproperties.values -match "#microsoft.graph.softwareOathAuthenticationMethod") { $softwareOathMethodsCount += 1 }
            if ($method.additionalproperties.values -match "#microsoft.graph.temporaryAccessPassAuthenticationMethod") { $temporaryAccessPassMethodsCount += 1 }
            #if ($method.additionalproperties.values -match "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod") {$MicrosoftAuthenticatorCount +=1}
            if ($method.additionalproperties.values -match "#microsoft.graph.emailAuthenticationMethod") { $EmailCount += 1 }
            if ($method.additionalproperties.values -match "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod") { $HelloForBusinessCount += 1 }
            if ($method.additionalproperties.values -match "#microsoft.graph.fido2AuthenticationMethod") { $FIDO2Count += 1 }
            if ($method.additionalproperties.values -match "#microsoft.graph.passwordAuthenticationMethod") { $PasswordCount += 1 }
        }


        # Create an object to store the user's information
        $object = [PSCustomObject]@{
                
            "User (UPN)"            = $user.userPrincipalName

            # The total (sum) of authentication methods:
            "Methods total"         = ($UserAuthMethod).count

            "Password"              = $PasswordCount
            "Phone(s)"              = $phoneCount
            "Email(s)"              = $EmailCount
            "Authenticator app(s)"  = $softwareOathMethodsCount
            "Windwos Hello(s)"      = $HelloForBusinessCount
            "FIDO2 security key(s)" = $FIDO2Count
            "Temporary Access Pass" = $temporaryAccessPassMethodsCount
            #"Microsoft Authenticator(s)"    = $MicrosoftAuthenticatorCount
        }
        [void]$AuthInfo.Add($object)
    }

    # Print the information on screen
    Write-Output " `nUsers in your tenant has the following authentication methods set:"
    $AuthInfo
    
}
Catch {
    Write-Error $PSItem   
}
