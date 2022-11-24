LICENSE:
--------
Created by: Jonas Markström
Last Updated: 2022-11-24
License: GNU

DISCLAIMER:
-----------
This feature is provided "as-is" without any warranty of any kind, either expressed or implied.

NOTE:
-----
This Administrative template (ADMX) adds the option to enable security key sign-in by setting a central GPO.
The template is intended to be used on Windows Server where Microsoft updated templates are not yet available.
As such, it augments the existing credentialprovider.admx with an additional setting. 

INSTRUCTIONS:
-------------
1.)	Copy the ADMX file (AddSecurityKeySupport.admx) to the following location on your domain controller / server: C:\Windows\PolicyDefinitions
2.)	Copy the ADML language file (AddSecurityKeySupport.adml) to the following location: C:\Windows\PolicyDefinitions\en-US
3.)	Restart the GPO Editor (if open)
4.) 	The settings are found when expanding (a GPO on:) 'Computer Configuration' > 'Policies' > 'Administrative Templates'> ' System' > 'Logon'

NOTE: Since the setting applies to the computer object, computers must have read access to the GPO.