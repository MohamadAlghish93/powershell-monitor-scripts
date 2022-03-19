
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

"10.51.61.65","10.51.61.66","10.51.61.135","10.51.61.136","10.51.61.67","10.51.61.68","10.51.61.69" | ForEach-Object -Process {

$Current_Server_IP = $_;

$session = new-pssession -computername $Current_Server_IP -credential $Credential

Invoke-Command -Session $session  -ArgumentList $Current_Server_IP  -ScriptBlock  {
param($Current_Server_IP)
Write-Host	" word  $Current_Server_IP " -ForegroundColor yellow  
Write-Host	" "
Get-Process -Name "*word*"
Write-Host	" "
Write-Host	"-----------"  -ForegroundColor Cyan

Write-Host	" Powerpnt  $Current_Server_IP" -ForegroundColor yellow  
Write-Host	" "
Get-Process -Name "*Powerpnt*"
Write-Host	" "
Write-Host	"-----------"  -ForegroundColor Cyan

}
Remove-PSSession $session


Write-Host	" "
}

Write-Host	"the script is finished"  -ForegroundColor Green  
start-sleep -s 120