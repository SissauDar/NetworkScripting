users = Get-ADGroupMember -identity "secretariaat"

foreach ($user in $users) { 
    $san = $user.SamAccountName
    Set-ADUser -Identity $user -Profilepath "\\DC2\Profiles$\$san"
}