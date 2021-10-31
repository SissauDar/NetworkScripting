 Invoke-Command -ComputerName MS -ScriptBlock {
             $homedir = "c:\homedirs"
             New-Item -Path $homedir -type directory -Force
             New-SmbShare -Name "homedirs" -Path $homedir -FullAccess "Everyone"         
             $acl = Get-Acl $homedir
             $acl.SetAccessRuleProtection($True, $False)
             $acl.Access | % { $acl.RemoveAccessRule($_) }
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule('administrators', 'FullControl', "ContainerInherit, objectInherit", "None", 'Allow')
             $acl.AddAccessRule($rule)
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule('Authenticated Users', 'ReadandExecute', "None", "None", "Allow")
             $acl.AddAccessRule($rule)
             (Get-Item $homedir).SetAccessControl($acl)
         }