Import-Module ActiveDirectory

$ADOUS = Import-Csv C:\Users\Administrator\Desktop\OU.csv -Delimiter ";"

foreach ($OU in $ADOUS) {
    $DisplayName = $OU.DisplayName
    $Name = $OU.Name
    $Description = $OU.Description
    $Path = $OU.Path
    Write-Host "$DisplayName"

    # New OU
    New-ADOrganizationalUnit `
        -DisplayName $DisplayName `
        -Name $Name `
        -Description $Description `
        -Path $Path
}