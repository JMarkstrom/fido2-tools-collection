# NOTE: you will need to run these commands as Administrator!

# ENABLE THE REQUIRED LOG:
$log = Get-WinEvent -ListLog 'Microsoft-Windows-DriverFrameworks-UserMode/Operational' 
$log.IsEnabled = $true 
$log.SaveChanges()
# IMPORT THE TASK
Register-ScheduledTask -xml (Get-Content "Lock workstation on YubiKey removal.xml" | Out-String) -TaskName "Lock workstation on YubiKey removal" -TaskPath "Yubico\" -Force