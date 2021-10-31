$hostname = Read-Host -Prompt "New hostname"
Rename-Computer -NewName $hostname -ComputerName $env:COMPUTERNAME -Confirm:$false -Restart