Import-Module ActiveDirectory # Using the Active Directory module


$ADOUS = Import-Csv C:\Users\Administrator\Desktop\OU.csv -Delimiter ";" # Reading our CSV file with the ; as delimiter


foreach ($OU in $ADOUS) { # Loop for each record in the CSV
    $DisplayName = $OU.DisplayName # Var that will get the DisplayName
    $Name = $OU.Name # Var that will get the Name
    $Description = $OU.Description # Var that will get the Description
    $Path = $OU.Path # Var that will get the path
    Write-Host "$DisplayName"

    # Creating a new OU with the vars included
    New-ADOrganizationalUnit `
        -DisplayName $DisplayName `
        -Name $Name `
        -Description $Description `
        -Path $Path
    Write-Host "The OU $Name is created." -ForegroundColor Green # Telling the user the OU has been created
}