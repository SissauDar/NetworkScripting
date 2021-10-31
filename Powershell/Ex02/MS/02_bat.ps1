New-Item \\DC1\netlogon\login.bat -ItemType File -Value "@echo off"
Add-Content \\DC1\netlogon\login.bat "`nnet use P: \\MS\Public"
