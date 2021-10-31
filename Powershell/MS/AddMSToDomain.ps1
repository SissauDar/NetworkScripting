 netsh interface ip set dns name="Ethernet0" static 192.168.1.2
 netsh interface ip add dns name="Ethernet0" 192.168.1.3 index=2
 add-computer -computername MS -domainname internal.company.be -credential Administrator -restart -force