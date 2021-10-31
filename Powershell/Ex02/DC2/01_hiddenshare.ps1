$dir = "c:\profiles"
New-Item -Path $dir -type directory -Force
New-SmbShare -Name 'profiles$' -Path $dir -FullAccess "Everyone"


$acl = Get-Acl $dir
$acl.SetAccessRuleProtection($True, $False)
$acl.Access | % { $acl.RemoveAccessRule($_) }
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('administrators', 'FullControl', "ContainerInherit, objectInherit", "None", 'Allow')
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule('Authenticated Users', 'Modify', "None", "None", "Allow")
$acl.AddAccessRule($rule)
(Get-Item $profilesFolder).SetAccessControl($acl)