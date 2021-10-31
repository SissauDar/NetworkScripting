 Invoke-Command -ComputerName MS -ScriptBlock {
             $folder = "c:\public"
             New-Item -Path $folder -type directory -Force
             New-SmbShare -Name "public" -Path $folder -FullAccess "Everyone"

             $acl = Get-Acl $folder
             $acl.SetAccessRuleProtection($True, $False)
             $acl.Access | % { $acl.RemoveAccessRule($_) }
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule('administrators', 'FullControl', "ContainerInherit, objectInherit", "None", 'Allow')
             $acl.AddAccessRule($rule)
             $rule = New-Object System.Security.AccessControl.FileSystemAccessRule('Authenticated Users', 'Modify', "ContainerInherit, objectInherit", "None", "Allow")
             $acl.AddAccessRule($rule)
             (Get-Item $folder).SetAccessControl($acl)
         }