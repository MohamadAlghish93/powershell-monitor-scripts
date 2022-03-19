$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")


"10.51.61.65","10.51.61.66","10.51.61.135","10.51.61.136"  | ForEach-Object -Process {

$Current_Server_IP = $_;
Write-Host " Stop IIS at  $Current_Server_IP "
$session = new-pssession -computername $Current_Server_IP -credential $Credential
Invoke-Command -Session $session   -ScriptBlock {


iisreset /STOP
Write-Host "---------------------------------------------------" 
}

Remove-PSSession $session
Write-Host " Stoping IIS at  $Current_Server_IP is done  "
}

start-sleep -s 120