Add-DhcpServerInDC -IPAddress 192.168.1.3 -DnsName dc2.internal.company.be
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2
Add-DhcpServerv4Failover -ComputerName dc1.internal.company.be -Name "SFO-SIN-Failover" -PartnerServer dc2.internal.company.be -ScopeId 192.168.1.0 -SharedSecret "P@ssw0rd"