   *    (     (                                        
 (  `   )\ )  )\ )     (      )            )           
 )\))( (()/( (()/(     )\  ( /(   (     ( /(   (  (    
((_)()\ /(_)) /(_))  (((_) )\()) ))\ (  )\()) ))\ )(   
(_()((_|_))_ (_))    )\___((_)\ /((_))\((_)\ /((_|()\  
|  \/  ||   \/ __|  ((/ __| |(_|_)) ((_) |(_|_))  ((_) 
| |\/| || |) \__ \   | (__| ' \/ -_) _|| / // -_)| '_| 
|_|  |_||___/|___/    \___|_||_\___\__||_\_\\___||_|   
MDS Checker - Readme
Author: Jonas Markström / swjm.blog
Version: 1.0.5

Release Date: December 21 2024

Description
===========
MDS Checker is a lightweight Windows utility that provides the following key features:

1. Presentation of YubiKey Model Name, Image, Firmware Version and Serial Number
3. Presentation of Fido Meta Data Service (MDS) inclusion (Yes/No)
4. If present in MDS, presentation of YubiKey FIDO certification(s) e.g. "L1" or "L2"
5. Presentation of YubiKey AAGUID in an IdP-friendly format with a copy control

These features greatly simplify tasks related to AAGUID white-listing and aides the user in assessing the likelihood of performing successful attestation checks.
In addition the utility helps the user assess current or pending security key certification status.

Installation
===========
1. Download the MSI
2. Double-click the MSI package to begin installation
3. Follow on-screen instructions to complete installation.

Usage
===========
1. Double-click MDS Checker desktop shortcut to run the app
2. Approve elevation (run-as) when prompted(!)
3. Insert a YubiKey to acquire it's attributes (this happens automatically)
4. Click the AAGUID field to copy it to clipboard
5. Optionally paste the AAGUID into your IdP (RP) for white-listing purposes.

NOTE: The app must be run as administrator!

Known Issues
============
1. Currently, the utility does not support multi-device detection.
2. Older Yubikeys (lacking FIDO applet) may not be correctly indentified.


Changelog
=========
Version 1.0.5: Website URL to align with other tools
Version 1.0.4: Added support for YubiKey BIO "MPE"
Version 1.0.3: Revised folder structure
Version 1.0.2: Corrected identification of FIPS YubiKeys
Version 1.0.1: Minor fixes to MSI packaging
Version 1.0.0: Initial release of MDS Checker

Legal Notices
==============
BSD 2-Clause License                                                             
Copyright (c) 2024, Jonas Markstrom

Redistribution and use in source and binary forms, with or
without modification, are permitted provided that the following
conditions are met:

    1. Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above
       copyright notice, this list of conditions and the following
       disclaimer in the documentation and/or other materials provided
       with the distribution.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
 ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.

