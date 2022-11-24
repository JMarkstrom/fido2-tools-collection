# Assembled list of Fido AAGUIDs 
The AAGUID, short for "Authenticator Attestation Globally Unique Identifier" is part of the FIDO2 specification. The AAGUID (in most cases) identifies the authenticator _make and model_. As such it allows the Relying Party (RP) or Identity Provider (IdP) a simple way to include (or exclude) authenticators during registration/enrollment and authentication without for example implementing the Fido Metadata Service.

Last updated: 2022-06-16 at 11:47

# Enable Security Key Logon

## Registry key
The [file](https://github.com/JMarkstrom/fido/blob/main/Enable-Security-Key-Logon.reg) `Enable-Security-Key-Logon.reg` contains a registry key that will enable security key logon on Windows 10 & Windows 11.

### Usage
To use this registry key, download it or save content to file (with .reg extension) and double-click on it.

## Administrative template (ADMX)
The archive [file](https://github.com/JMarkstrom/fido/blob/main/Enable-Security-Key-Sign-in-ADMX-1.0.zip) `Enable-Security-Key-Sign-in-ADMX-1.0.zip` adds security key sign-in as a GPO control to the existing credentialproviders.admx view (not the file itself) to "augment" a Windows Server GPO where this control is not yet available (e.g on Windows Server 2019 and earlier).

### Usage
For usage instructions, see readme.txt inside the archive.

## Provisioning package
The [file](https://github.com/JMarkstrom/fido/raw/main/Enable-Security-Key-Sign-in-1.0.ppkg) `Enable-Security-Key-Sign-in-1.0.ppkg` contains a provisioning package that will enable security key logon on Windows 10 & Windows 11. The package is unsigned and not encryped.

### Usage
To use this package download it and double-click on it (or import into Windows Configuration Designer and go from there).
