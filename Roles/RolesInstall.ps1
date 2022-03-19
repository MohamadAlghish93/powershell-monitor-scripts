$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

#Export Features & Roles
#Get-WindowsFeature | Where{$_.Installed -eq $True} | select name | Export-csv C:\Roles.csv -NoTypeInformation -Verbose
"10.51.45.31","10.51.45.32","10.51.45.33","10.51.45.34","10.51.45.35","10.51.45.36"  | ForEach-Object -Process {

$Current_Server_IP = $_;

$session = new-pssession -computername $Current_Server_IP -credential $Credential

Invoke-Command -Session $session   -ScriptBlock {
New-Item -Type Directory C:\sxs\
}
copy-item C:\Roles.csv  C:\Roles.csv -ToSession  $session
copy-item C:\sxs\*  C:\sxs\ -ToSession  $session

Invoke-Command -Session $session   -ScriptBlock {
 Import-Csv C:\Roles.csv | foreach{Add-WindowsFeature $_.name -Source C:\sxs\}
}


Remove-PSSession $session

}

start-sleep -s 120