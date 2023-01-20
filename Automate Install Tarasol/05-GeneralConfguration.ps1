

echo "Start Confguration"

echo "System Locale settings"
Set-WinSystemLocale ar-AE

echo "Assigning file access rights to IIS_IUSRS"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl = Get-ACL "c:\inetpub\wwwroot"
$acl.AddAccessRule($accessRule)
Set-ACL -Path "c:\inetpub\wwwroot" -ACLObject $acl

echo "End Confguration"

start-sleep -s 120