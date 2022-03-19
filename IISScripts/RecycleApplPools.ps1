$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")
$Interval_Time = 2   #in Minute

"10.51.61.65","10.51.61.66","10.51.61.135","10.51.61.136"  | ForEach-Object -Process {

$Current_Server_IP = $_;
Write-Host " Recycling AppPools at  $Current_Server_IP "
$session = new-pssession -computername $Current_Server_IP -credential $Credential
Invoke-Command -Session $session   -ScriptBlock {
Write-Host " Recycling TarasolAPI4 at  $Current_Server_IP "
 Import-Module WebAdministration
 $site="Default Web Site"
 $pool = (Get-Item "IIS:\Sites\$site\TarasolAPI4"| Select-Object applicationPool).applicationPool
  Restart-WebAppPool $Pool
 
 Write-Host " -------------------------------- "
 $pool = (Get-Item "IIS:\Sites\$site\TarasolSite"| Select-Object applicationPool).applicationPool
 Restart-WebAppPool $Pool

}

Remove-PSSession $session
Write-Host " Recycling AppPools at  $Current_Server_IP is done  "
Write-Host "...... Waiting $Interval_Time Minutes "
Start-Sleep -s (60*$Interval_Time)
Write-Host "---------------------------------------------------" 
}

Start-Sleep -s 120