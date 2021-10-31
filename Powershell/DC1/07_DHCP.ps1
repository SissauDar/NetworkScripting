Install-WindowsFeature -Name 'DHCP' –IncludeManagementTools -Restart # Installing the DHCP Server and restarting the PC in th same command


$dnsArray = "192.168.1.2","192.168.1.3" # Var for giving the two DNS Servers, DC1 and DC2
$macPrinter = "b8-e9-37-3e-55-86" # Var with MAC of printer
Add-DhcpServerInDC -DnsName "dc1.internal.company.be" -IPAddress 192.168.1.2 # Adding a DHCP Server on our DC1
Add-DhcpServerV4Scope -Name "Kortrijk" -StartRange 192.168.1.1 -EndRange 192.168.1.254 -SubnetMask 255.255.255.0 # Adding a new scope on that DHCP Server
Set-DhcpServerV4OptionValue -DnsServer $dnsArray -Router 192.168.1.1 -Force # Adding the DNS servers to the scope, also giving a Gateway
Add-Dhcpserverv4ExclusionRange -ScopeId 192.168.1.0 -StartRange 192.168.1.1 -EndRange 192.168.1.10 # Adding an Exclusion range to the Scope.
Add-DhcpServerv4Reservation -ScopeId 192.168.1.0 -IPAddress 192.168.1.11 -ClientId $macPrinter -Description "Reservation for Printer" # Making a reservation for the printer in the scope

Set-ItemProperty registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 -Name ConfigurationState -Value 2 # Removing the Post-install-configuration warning in Server Manager
