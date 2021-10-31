$ComputerName = "MS"

 Invoke-Command -ComputerName $ComputerName -ScriptBlock {
             $homeFolder = "c:\homedirs"
             Write-Host "Creating Home Folder"
             New-Item -Path $homeFolder -type directory -Force

             Write-Host "Making home folder a share"
             New-SmbShare -Name "homedirs" -Path $homeFolder -FullAccess "Everyone"

             
             $acl = Get-Acl $homeFolder
             $acl.SetAccessRuleProtection($True, $False)
             $acl.Access | % { $acl.RemoveAccessRule($_) } # I remove all security
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule('administrators', 'FullControl', "ContainerInherit, objectInherit", "None", 'Allow') # I set my admin account as also having access
             $acl.AddAccessRule($rule)
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule('Authenticated Users', 'ReadandExecute', "None", "None", "Allow")
             $acl.AddAccessRule($rule)
             (Get-Item $homeFolder).SetAccessControl($acl)
         }