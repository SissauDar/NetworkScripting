Import-Module ActiveDirectory
$ADUsers = Import-Csv C:\Users\Administrator\Desktop\OU.csv -Delimiter ";"

$UPN = "mijnschool.be"

foreach ($User in $ADUsers) {

    $Username = $User.Name.ToLower().replace(' ' , '""')
    $Name = $User.Name
    $SamAccountName = $User.SamAccountName
    $GivenName = $User.GivenName
    $Surname = $User.Surname
    $DisplayName = $User.DisplayName
    $AccountPassword = $User.AccountPassword
    $HomeDrive = $User.HomeDrive
    $HomeDirectory = "\\ms\homedirs\$Username"
    $ScriptPath = $User.ScriptPath
    $Path = $User.Path
    Write-Host "Creating user $Name" -ForegroundColor Green

        New-ADUser `
            -UserPrincipalName "$username@$UPN" `
            -Name $Name `
            -SamAccountName $SamAccountName `
            -GivenName $GivenName `
            -Surname $Surname `
            -DisplayName $DisplayName `
            -AccountPassword (ConvertTo-secureString $AccountPassword -AsPlainText -Force) `
            -HomeDrive $HomeDrive `
            -HomeDirectory $HomeDirectory `
            -ScriptPath $ScriptPath `
            -Path $Path `
            -Enabled $True

    Write-Host "    Creating Home folder for user $Name" -ForegroundColor DarkGreen
        
        # Making A Home Directory for the user and changing the Permissions so that the user can Modify in the folder.
        New-Item -Path $HomeDirectory -type directory -Force
        $acl = Get-Acl $HomeDirectory
        $acl.SetAccessRuleProtection($False, $True)
        $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($Username, 'Modify', "ContainerInherit, ObjectInherit", "None", "Allow")
        $acl.AddAccessRule($rule)
        (Get-Item $HomeDirectory).SetAccessControl($acl)
}