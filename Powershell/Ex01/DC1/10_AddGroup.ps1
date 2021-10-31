Import-Module ActiveDirectory
$AddGroups = Import-Csv -Path "C:\Users\Administrator\Desktop\groups.csv" -Delimiter ";"
 
ForEach($Group In $AddGroups)
{
    $Name = $Group.Name
    $DisplayName = $Group.DisplayName
    $Path = $Group.Path
    $GroupScope = $Group.GroupScope
    $GroupCategory = $Group.GroupCategory
    $Desciption = $Group.Description



    $GroupExists = Get-ADGroup -Identity $GroupName
    if(!$GroupExists){
      $CreateGroup = New-ADGroup `
        -Name $Name `
        -DisplayName $DisplayName `
        -Path $Path `
        -GroupScope $GroupScope `
        -GroupCategory $GroupCategory `
        -Description $Desciption | set-ADOrganizationalUnit –ProtectedFromAccidentalDeletion $false
            Write-Host "Creating Group $Name" -ForegroundColor Green
    }else{
        Write-Host "Group $Name already exsist" -ForegroundColor Red
    }

  

}