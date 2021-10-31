#Register-DnsClient
#New-ADReplicationSite -Name "Kortrijk"
#New-ADReplicationSubnet -Name "192.168.1.0/24" -Site Kortrijk -Location "Belgium"
#Get-ADReplicationSubnet -Filter * |Ft Location,Name,Site
#Move-ADDirectoryServer -Identity "DC1" -Site "Kortrijk"

Get-ADObject -SearchBase (Get-ADRootDSE).ConfigurationNamingContext -filter “objectclass -eq 'site'” | Rename-ADObject -NewName Kortrijk