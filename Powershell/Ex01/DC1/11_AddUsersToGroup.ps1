Import-Module ActiveDirectory
$GroupUsers = Import-Csv C:\Users\Administrator\Desktop\GroupUsers.csv -Delimiter ";"

ForEach($Mem In $GroupUsers)
{
    $CreateGroup = Add-ADGroupMember `
        -Identity $Mem.Identity `
        -Members $Mem.Member
}