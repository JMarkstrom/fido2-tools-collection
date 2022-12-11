  
##########################################################################
# Enforce Security Key Sign-in                     
##########################################################################
# version: 1.1
# last updated on: 2022-126-11 by Jonas Markström (https://swjm.blog)
# original script by: Craig Wilson (https://craigwilson.blog/)
# see readme.md for more info.
#
# NOTE: This script enforces FIDO2 Security Key sign-in to Windows clients
# by disabling (disallowing) alternative methods. Before disabling any 
# credential provider please consider possible adverse effect of doing so; 
# The removal of a credential provider not only affects Windows logon, but 
# also important functionality once the user is logged in, like for example:
# User Account Control (UAC) dialogs and Run As(!).
#
# LIMITATIONS/ KNOWN ISSUES: N/A
#
# ************************************************************************
# DISCLAIMER: This script is provided "as-is" without any warranty of
# any kind, either expressed or implied.
# ************************************************************************
#
##########################################################################

# Disabled flag, used to check and enable or disable login provider.
# 1 = Disabled credential provider
# 0 = Enabled credential provider
$DisbaleFlag = "1" 

# Registry keys for removing credential providers.
$registryKeys =
@(
	# PASSWORD	
	[pscustomobject]@{Name="PasswordProvider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{60b78e88-ead8-445c-9cfd-0b87f74ea6cd}";Key="Disabled";Value="1"},
    
	# WINDOWS HELLO
	[pscustomobject]@{Name="PINLogonProvider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{cb82ea12-9f71-446d-89e1-8d0924e1256e}";Key="Disabled";Value="1"},
    [pscustomobject]@{Name="IrisCredentialProvider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{C885AA15-1764-4293-B82A-0586ADD46B35}";Key="Disabled";Value="1"},
    [pscustomobject]@{Name="NGC Credential Provider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{D6886603-9D2F-4EB2-B667-1971041FA96B}";Key="Disabled";Value="1"}
	[pscustomobject]@{Name="FaceCredentialProvider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{8AF662BF-65A0-4D0A-A540-A338A999D36F}";Key="Disabled";Value="1"}
   	[pscustomobject]@{Name="WinBio Credential Provider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{BEC09223-B018-416D-A0AC-523971B639F5}";Key="Disabled";Value="1"}
	
	# PICTURE PIN
	[pscustomobject]@{Name="PicturePasswordLogonProvider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{2135f72a-90b5-4ed3-a7f1-8bb705ac276a}";Key="Disabled";Value="1"}
	
	# SMART CARD
	#[pscustomobject]@{Name="Smartcard Reader Selection Provider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{1b283861-754f-4022-ad47-a5eaaa618894}";Key="Disabled";Value="1"}
	#[pscustomobject]@{Name="Smartcard WinRT Provider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{1ee7337f-85ac-45e2-a23c-37c753209769}";Key="Disabled";Value="1"}
	#[pscustomobject]@{Name="Smartcard Credential Provider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{8FD7E19C-3BF7-489B-A72C-846AB3678C96}";Key="Disabled";Value="1"}
	#[pscustomobject]@{Name="Smartcard Pin Provider";Location="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\Credential Providers\{94596c7e-3744-41ce-893e-bbf09122f76a}";Key="Disabled";Value="1"}
)
Write-output "Starting check for providers." | Out-File $env:temp\credprovlog.txt
Write-output "" | Out-File $env:temp\credprovlog.txt
foreach ($registrykey in $registryKeys)
{
    Write-output "Checking Credential Provider $($registrykey.Name)" | Out-File $env:temp\credprovlog.txt
    Write-output "----------------------------------------------------------------------------------------" | Out-File $env:temp\credprovlog.txt
    $value = (Get-ItemProperty $registrykey.Location  -ErrorAction SilentlyContinue).$($registrykey.Key)
    If ($value -eq "1") 
    {
        Write-output "  $($registrykey.Name) Credential Provider exists, currently set to disabled login." | Out-File $env:temp\credprovlog.txt
        If ($DisbaleFlag -eq "0")
        {
            Write-output "  Enabling Credential Provider $($registrykey.Name)" | Out-File $env:temp\credprovlog.txt
            try 
            {
                New-ItemProperty -Path $registrykey.Location -Name $($registrykey.Key) -Value "0" -Force -ErrorAction SilentlyContinue  | Out-Null
            }
            catch
            {
                Write-output "  Error - Enabling Credential Provider $($registrykey.Name)" | Out-File $env:temp\credprovlog.txt
            }
        }
    }
    Else
    {
        Write-output "  $($registrykey.Name) Credential Provider exists does not exist or is set to enabled"
        If ($DisbaleFlag -eq "1")
        {
            Write-output "  Disabling Credential Provider $($registrykey.Name)" | Out-File $env:temp\credprovlog.txt
            try 
            {
                New-ItemProperty -Path $registrykey.Location -Name $($registrykey.Key) -Value "1" -Force -ErrorAction SilentlyContinue | Out-Null
            }
            catch
            {
                Write-output "  Error - Disabling Credential Provider $($registrykey.Name)" | Out-File $env:temp\credprovlog.txt
            }
        }
    }
    Write-output "----------------------------------------------------------------------------------------" | Out-File $env:temp\credprovlog.txt
}
Write-output "Completed." | Out-File $env:temp\credprovlog.txt