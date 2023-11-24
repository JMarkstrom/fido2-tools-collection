# Assembled list of Fido AAGUIDs 
The AAGUID, short for "Authenticator Attestation Globally Unique Identifier" is part of the FIDO2 specification. The AAGUID (in most cases) identifies the authenticator _make and model_. As such it allows the Relying Party (RP) or Identity Provider (IdP) a simple way to include (or exclude) authenticators during registration/enrollment and authentication without for example implementing the Fido Metadata Service.

Last updated: 2022-06-16 at 11:47

# Enable Security Key Logon

## Registry keys
The [file](https://github.com/JMarkstrom/fido/blob/main/Enable-Security-Key-Logon.reg) `Enable-Security-Key-Logon.reg` contains a registry key that will enable security key logon on Windows 10 & Windows 11.

### 📖 Usage
To use this registry key, download it or save content to file (with .reg extension) and double-click on it.

## Administrative template (ADMX)
The archive [file](https://github.com/JMarkstrom/fido/blob/main/Enable-Security-Key-Sign-in-ADMX-1.0.zip) `Enable-Security-Key-Sign-in-ADMX-1.0.zip` adds security key sign-in as a GPO control to the existing credentialproviders.admx view (not the file itself) to "augment" a Windows Server GPO where this control is not yet available (e.g on Windows Server 2019 and earlier).

### 📖 Usage
For usage instructions, see readme.txt inside the archive.

## Provisioning package
The [file](https://github.com/JMarkstrom/fido/raw/main/Enable-Security-Key-Sign-in-1.0.ppkg) `Enable-Security-Key-Sign-in-1.0.ppkg` contains a provisioning package that will enable security key logon on Windows 10 & Windows 11. The package is unsigned and not encryped.

### 📖 Usage
To use this package download it and double-click on it (or import into Windows Configuration Designer and go from there).

# Enforce Security Key Logon

## Registry keys
The [file](https://github.com/JMarkstrom/fido/blob/main/Disable-PasswordProvider.reg) `Disable-PasswordProvider.reg` contains a registry key that will DISABLE password-based logon on Windows 10 & Windows 11.

### 📖 Usage
To use this registry key, download it or save content to file (with .reg extension) and double-click on it.
To disable _ _additional_ _ credential providers you can expand this key using a listing provided at https://swjm.blog

## script
The [file](https://github.com/JMarkstrom/fido/blob/main/Enforce_security_key_sign-in.ps1) `Enforce_security_key_sign-in.ps1` constitutes a PowerShell script meant for **Microsoft Endpoint Manager** (Intune) configuration of Windows 10 and 11 clients. The script is _ _adapted_ _ from an original script created by **Craig Wilson** (https://craigwilson.blog/) and works by DISABLING alternative credential providers.

### 📖 Usage
See: https://swjm.blog


# Add Kerberos object from on-premise AD to Azure AD           
The [file](https://github.com/JMarkstrom/fido/blob/main/Add-Kerberos-object-to-AAD.ps1) `Add-Kerberos-object-to-AAD.ps1` PowerShell script is designed to establish an Azure AD Kerberos Server object within your on-premise AD, enabling seamless FIDO2 (SSO) access to on-premise resources like network shares. It's important to note that this isn't mandatory for FIDO2 security key sign-in, but it does broaden the scope of security key utilization beyond PC login.

### 📖 Usage
See: https://swjm.blog

# Terms of Use (ToU) Passkeys
The [file](https://github.com/JMarkstrom/fido/blob/main/Terms-of-Use-(ToU)-Passkeys.pdf) `Terms-of-Use-(ToU)-Passkeys.pdf` is an example of a "Terms of Use" (ToU) that can be presented to users when accessing company resources. This example ToU stipulates that users must set a non-trivial PIN on the security key and transfers the responsibility to the user. 

### 📖 Usage
See: https://swjm.blog

