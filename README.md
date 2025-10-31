# 🧰 FIDO2 Tools Collection

## Table of Contents
[Security Key EOBO](#security-key-eobo)    
[MDS Checker](#mds-checker)  
[OTP2Serial](#otp2serial)  
[YubiKey PIN Generator](#yubikey-pin-generator)  
[Enforce Security Key Logon](#enforce-security-key-logon)  
[Add Kerberos object for Entra ID](#add-kerberos-object-for-entra-id)  
[Terms of Use (ToU) Passkeys](#terms-of-use-tou-passkeys)  
[PIN Hygiene (do's and don'ts)](#pin-hygiene)  

## Security Key EOBO
Security Key EOBO (Enrollment On Behalf Of) facilitates Yubikey configuration and enrollment in Microsoft Entra ID.

![](/images/security-key-eobo-with-microsoft-entra-id.1.2.gif)

**NOTE**: This project is found in a separate repository [here](https://github.com/JMarkstrom/entra-id-security-key-obo-enrollment).

## MDS Checker
MDS Checker is a lightweight Windows utility that provides the following key features:

- Presentation of YubiKey **Model Name**, **Image**, **Firmware Version** _and_ **Serial Number**
- Presentation of Fido Meta Data Service (MDS) inclusion (Yes/No)
- If present in MDS, presentation of YubiKey FIDO certification(s) e.g. "**L1**" or "**L2**"
- Presentation of YubiKey **AAGUID** in an IdP-friendly format with a copy control


![](/images/mds-checker.png)

_These features greatly simplify tasks related to AAGUID white-listing and aides the user in assessing the likelihood of performing successful attestation checks.
In addition the utility helps the user assess current or pending security key certification status._

### 💾 Installation
1. Download the MSI [here](/mds-checker/)
2. Double-click the MSI package to begin installation
3. Follow on-screen instructions to complete installation.

### 📖 Usage
1. Double-click the ```MDS Checker``` desktop shortcut to run the app
2. Approve elevation (run-as) when prompted(!)
3. Insert a YubiKey to acquire it's attributes (this happens automatically)
4. Use the Copy button to copy the AAGUID to clipboard
5. Optionally paste the AAGUID into your IdP (RP) for white-listing purposes.

**NOTE**: The app must be run as administrator!

### 🥷🏻 Contributing
You can help by getting involved in the project, _or_ by donating (any amount!).   
Donations will support costs such as domain registration and code signing (planned).

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?business=RXAPDEYENCPXS&no_recurring=1&item_name=Help+cover+costs+of+the+SWJM+blog+and+app+code+signing%2C+supporting+a+more+secure+future+for+all.&currency_code=USD)


## OTP2Serial
The [OTP2Serial](/OTP2Serial/) app demonstrates convertion of a YubiOTP (Yubico OTP) to a YubiKey Serial Number.

![](/images/OTP2Serial.png)

**NOTE**: The relevant code snippet in is provided below.

```csharp
if (publicId.StartsWith("vv"))
{
    publicId = "cc" + publicId.Substring(2);
}

char[] publicIdArray = { 'c', 'b', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'n', 'r', 't', 'u', 'v' };
var hexString = string.Concat(publicId.Select(c => Array.IndexOf(publicIdArray, c).ToString("X")));

var serial = Convert.ToInt32(hexString, 16);
return serial.ToString();
```

### 🥷🏻 Contributing
You can help by getting involved in the project, _or_ by donating (any amount!).   
Donations will support costs such as domain registration and code signing (planned).

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/donate/?business=RXAPDEYENCPXS&no_recurring=1&item_name=Help+cover+costs+of+the+SWJM+blog+and+app+code+signing%2C+supporting+a+more+secure+future+for+all.&currency_code=USD)


## YubiKey PIN Generator
The [YubiKey PIN Generator](/yubikey-pin-gen.py) is a Python script that facilitates configuration of a YubiKey(s). The script:

- Sets a random and non-trivial PIN (default: ```4``` digits)
- If selected (and supported by the YubiKey) sets PIN to expire on first use
- Prints YubiKey model, serial number, intial PIN (and change flag) to a JSON output file
- Prompts for configuration of additional YubiKey(s).
  
![](/images/yubikey-pin-gen.gif)

## 💻 Prerequisites
The following are prerequisites towards running the script:

- [Python](https://www.python.org/downloads/) installed on client
- [Python-fido2](https://github.com/Yubico/python-fido2) installed on client
- [Yubikey Manager](https://github.com/Yubico/yubikey-manager) (CLI) installed on client. 

**NOTE**: Refer to [swjm.blog](https://swjm.blog) for _detailed_ setup instructions.

### 📖 Usage
To run the script, simply execute command: `python yubikey-pin-gen.py`

**NOTE**: Refer to [swjm.blog](https://swjm.blog) for _detailed_ usage instructions.

## 🗎 The output.json file
The script will outout a file on working directory called output.json. 

Here is an example: 

```json
[
    {
      "Model": "YubiKey 5C NFC",
      "Serial number": 12345678,
      "PIN": "6855",
      "PIN change required": true
    }
]
```
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


# Add Kerberos object for Entra ID           
The [file](https://github.com/JMarkstrom/fido/blob/main/Add-Kerberos-object-for-Entra-ID.ps1) `Add-Kerberos-object-for-Entra-ID.ps1` PowerShell script is designed to establish an Azure AD Kerberos Server object within your on-premise AD, enabling seamless FIDO2 (SSO) access to on-premise resources like network shares. It's important to note that this isn't mandatory for FIDO2 security key sign-in, but it does broaden the scope of security key utilization beyond PC login.

### 📖 Usage
See: https://swjm.blog

# Terms of Use (ToU) Passkeys
The [file](https://github.com/JMarkstrom/fido/blob/main/Terms-of-Use-(ToU)-Passkeys.pdf) `Terms-of-Use-(ToU)-Passkeys.pdf` is an example of a "Terms of Use" (ToU) that can be presented to users when accessing company resources. This example ToU stipulates that users must set a non-trivial PIN on the security key and transfers the responsibility to the user. 

### 📖 Usage

![](/images/ToU.gif)

See: [swjm.blog](https://swjm.blog/implementing-a-fido2-terms-of-use-tou-for-microsoft-entra-637dcb5ca142)


## PIN Hygiene
See printable example (make a sticker?) [here](https://github.com/JMarkstrom/fido2-tools-collection/blob/main/YubiKey-PIN-Hygiene-Poster.pdf) and source (edit to your liking) [here](https://github.com/JMarkstrom/fido2-tools-collection/blob/main/YubiKey-PIN-Hygiene-Source.md).

![](/images/YubiKey-PIN-Hygiene.png)


