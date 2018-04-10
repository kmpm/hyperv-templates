HyperV-Templates
================
Packer templates optimized for Hyper-V and for running the 
build on Windows with PowerShell.

Based upon work done by https://github.com/jacqinthebox/packer-templates

# Dependencies
You will mkisofs.exe in this project directory. It can be downloaded at
https://opensourcepack.blogspot.se/p/cdrtools.html

# Utilities
```powershell
certutil -hashfile .\isos\14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO md5
``` 

# ISO Urls
```json
{
    "server2016eval": {
        "url": "http://download.microsoft.com/download/1/4/9/149D5452-9B29-4274-B6B3-5361DBDA30BC/14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO",
        "md5": "70721288bbcdfe3239d8f8c0fae55f1f"
    }
}
```
