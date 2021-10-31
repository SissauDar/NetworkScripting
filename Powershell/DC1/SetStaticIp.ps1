$IP = "192.168.1.2" #Read-Host -Prompt "Ip? "
$MaskBits = 24 # This means subnet mask = 255.255.255.0
$Gateway = "192.168.1.1" #Read-Host -Prompt "Gateway? "
$PrimaryDns = "172.20.0.2" #Read-Host -Prompt "Primary DNS? "
$SecondaryDns = "172.20.0.3" #Read-Host -Prompt "Secondary DNS? "
$Dns = ($PrimaryDns, $SecondaryDns)
$IPType = "IPv4"
 

# Retrieve the network adapter that you want to configure
#$adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
$adapter= Get-Netadapter -Physical | Where-Object { $_.PhysicalMediaType -match "802.3" -and $_.status -eq "up"}

# Remove any existing IP, gateway from our ipv4 adapter
if (($adapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
}
if (($adapter | Get-NetIPConfiguration).Ipv4DefaultGateway) {
    $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
}
 # Configure the IP address and default gateway
$adapter | New-NetIPAddress `
 -AddressFamily $IPType `
 -IPAddress $IP `
 -PrefixLength $MaskBits `
 -DefaultGateway $Gateway
# Configure the DNS client server IP addresses
$adapter | Set-DnsClientServerAddress -ServerAddresses $DNS
 
# Disable ipv6
Disable-NetAdapterBinding –InterfaceAlias $adapter.Name –ComponentID ms_tcpip6