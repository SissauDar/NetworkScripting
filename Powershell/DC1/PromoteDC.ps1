Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
Test-ADDSForestInstallation -DomainName internal.company.be -InstallDns
Install-ADDSForest -DomainName internal.company.be -InstallDNS