$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")


"10.51.45.31","10.51.45.32","10.51.45.33","10.51.45.34","10.51.45.35","10.51.45.36"  | ForEach-Object -Process {

$Current_Server_IP = $_;

$session = new-pssession -computername $Current_Server_IP -credential $Credential

Invoke-Command -Session $session   -ScriptBlock {
Write-Host "Restarting $Current_Server_IP " 
Restart-Computer -Force
}

Remove-PSSession $session

}

start-sleep -s 120