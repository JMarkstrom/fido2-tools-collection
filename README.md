# Fido AAGUID 
The AAGUID or the "Authenticator Attestation Globally Unique Identifier" is part of the FIDO2 specification. The AAGUID (in most cases) identifies the authenticator _make and model_. As such it allows the Relying Party (RP) or Identity Provider (IdP) a simple way to include (or exclude) authenticators during registration/enrollment and authentication without for example implementing the Fido Metadata Service.


MAKE,MODEL,FW,AAGUID
Apple,FaceID,-,(all zeroes)
Apple,TouchID,-,(all zeroes)
Feitian,ePassFIDO K10,3.4.01,833b721a-ff5f-4d00-bb2e-bdda3ec01e29
Feitian,ePassFIDO A4B,3.4.01,833b721a-ff5f-4d00-bb2e-bdda3ec01e29
Feitian,ePassFIDO K28,3.4.01,833b721a-ff5f-4d00-bb2e-bdda3ec01e29
Feitian,ePassFIDO K39,3.2.04,ee041bce-25e5-4cdb-8f86-897fd6418464
Feitian,ePassFIDO NFC K9,3.2.04,ee041bce-25e5-4cdb-8f86-897fd6418464
Feitian,ePassFIDO NFC Plus K9,3.2.04,ee041bce-25e5-4cdb-8f86-897fd6418464
Feitian,ePassFIDO NFC K40,3.2.04,ee041bce-25e5-4cdb-8f86-897fd6418464
Feitian,ePassFIDO NFC Plus K40,3.2.04,ee041bce-25e5-4cdb-8f86-897fd6418464
Feitian,MultiPass FIDO K13,3.9.01,310b2830-bd4a-4da5-832e-9a0dfc90abf2
Feitian,MultiPass FIDO K25,3.9.01,310b2830-bd4a-4da5-832e-9a0dfc90abf2
Feitian,BioPass FIDO K26,1.5.02,77010bd7-212a-4fc9-b236-d2ca5e9d4084
Feitian,BioPass FIDO Plus K26,1.5.03,b6ede29c-3772-412c-8a78-539c1f4c62d2
Feitian,BioPass FIDO K27,1.5.02,77010bd7-212a-4fc9-b236-d2ca5e9d4084
Feitian,BioPass FIDO Plus K27,1.5.03,b6ede29c-3772-412c-8a78-539c1f4c62d2
Feitian,BioPass FIDO K45,4.3.11,77010bd7-212a-4fc9-b236-d2ca5e9d4084
Feitian,BioPass FIDO Plus K45,1.4.53,b6ede29c-3772-412c-8a78-539c1f4c62d2
Feitian,AllinPass FIDO K33,4.4.01,12ded745-4bed-47d4-abaa-e713f51d6393
Feitian,AllinPass FIDO K43,4.2.21,12ded745-4bed-47d4-abaa-e713f51d6393
Feitian,iePass FIDO K44,1.579,6e22415d-7fdf-4ea4-8a0c-dd60c4249b9d
Feitian,FIDO Java Card,-,2c0df832-92de-4be1-8412-88a8f074df4a
Feitian,FIDO Fingerprint Card,-,8c97a730-3f7b-41a6-87d6-1e9b62bda6f0
HID,Crescendo C2300,-,aeb6569c-f8fb-4950-ac60-24ca2bbe2e52
HID,Crescendo Key,-,692db549-7ae5-44d5-a1e5-dd20a493b723
Microsoft,Windows Hello Software Authenticator,-,6028b017-b1d4-4c02-b4b3-afcdafc96bb2
Microsoft,Windows Hello Hardware Authenticator,-,08987058-cadc-4b81-b6e1-30de50dcbe96
Microsoft,Windows Hello VBS Hardware Authenticator,-,9ddd1817-af5a-4672-a2b9-3e3dd95000a9
Thales,eToken FIDO,-,efb96b10-a9ee-4b6c-a4a9-d32125ccd4a4
Thales,IDPrime MD 3940 FIDO,-,b50d5e0a-7f81-4959-9b12-f45407407503
Yubico,Yubikey 5 (USB-A No NFC),5.1,cb69481e-8ff7-4039-93ec-0a2729a154a8
Yubico,YubiKey 5 (USB-A No NFC),5.2/5.4,ee882879-721c-4913-9775-3dfcce97072a
Yubico,YubiKey 5 NFC,5.1,fa2b99dc-9e39-4257-8f92-4a30d23c4118
Yubico,YubiKey 5 NFC,5.2/5.4,2fc0579f-8113-47ea-b116-bb5a8db9202a
Yubico,YubiKey 5 NFC FIPS,5.4,c1f9a0bc-1dd2-404a-b27f-8e29047a43fd
Yubico,YubiKey 5 Nano,5.1,cb69481e-8ff7-4039-93ec-0a2729a154a8
Yubico,YubiKey 5 Nano,5.2/5.4,ee882879-721c-4913-9775-3dfcce97072a
Yubico,YubiKey 5 Nano FIPS,5.4,73bb0cd4-e502-49b8-9c6f-b59445bf720b
Yubico,YubiKey 5C,5.1,cb69481e-8ff7-4039-93ec-0a2729a154a8
Yubico,YubiKey 5C,5.2/5.4,ee882879-721c-4913-9775-3dfcce97072a
Yubico,YubiKey 5C FIPS,5.4,73bb0cd4-e502-49b8-9c6f-b59445bf720b
Yubico,YubiKey 5C Nano,5.1,cb69481e-8ff7-4039-93ec-0a2729a154a8
Yubico,YubiKey 5C Nano,5.2/5.4,ee882879-721c-4913-9775-3dfcce97072a
Yubico,YubiKey 5C Nano FIPS,5.4,73bb0cd4-e502-49b8-9c6f-b59445bf720b
Yubico,YubiKey 5C NFC,5.2/5.4,2fc0579f-8113-47ea-b116-bb5a8db9202a
Yubico,YubiKey 5C NFC FIPS,5.4,c1f9a0bc-1dd2-404a-b27f-8e29047a43fd
Yubico,YubiKey 5Ci,5.2/5.4,c5ef55ff-ad9a-4b9f-b580-adebafe026d0
Yubico,YubiKey 5Ci FIPS,5.4,85203421-48f9-4355-9bc8-8a53846e5083
Yubico,Security Key By Yubico,5.1,f8a011f3-8c0a-4d15-8006-17111f9edc7d
Yubico,Security Key By Yubico,5.2,b92c3f9a-c014-4056-887f-140a2501163b
Yubico,Security Key NFC,5.1,6d44ba9b-f6ec-2e49-b930-0c8fe920cb73
Yubico,Security Key NFC,5.2,149a2021-8ef6-4133-96b8-81f8d5b7f1f5
Yubico,YubiKey Bio Series,5.5,d8522d9f-575b-4866-88a9-ba99fa02f35b
