$fileName = "C:\Users\dar\Desktop\firstrun.sh"
$file_data = Get-Content C:\Users\dar\Desktop\fallback.txt
$pattern = "Computer Networks section"
$write = "True"


$SEL = Select-String -Path $fileName -Pattern $pattern

if ($SEL -ne $null)
{
    $write = "False"
    Write-Output("Network section is already added")
}
else
{
       if($write -eq "True"){

            (Get-Content $fileName) | 
                Foreach-Object {
                    $_ # send the current line to output
                    if ($_ -match "dpkg-reconfigure -f noninteractive keyboard-configuration") 
                    {
                        #Add Lines after the selected pattern
                        $file_data
            
                    }
                } | Set-Content $fileName

    }
    Write-Output("Network section added")
}






