Install-ADDSDomainController -DomainName "internal.company.be" -InstallDns:$true
Get-ADDomainController -Filter * | ft