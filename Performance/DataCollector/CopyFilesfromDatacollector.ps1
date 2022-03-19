$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")


$LocalPerformanceMetricsDir = "D:\PerformanceMetricsDataColletor\" 
     if (-Not (Test-Path $LocalPerformanceMetricsDir )){
       New-Item -Type Directory $LocalPerformanceMetricsDir
     }
"10.51.61.65","10.51.61.66","10.51.61.135","10.51.61.136" | ForEach-Object -Process {

$Current_Server_IP = $_; 

$session = new-pssession -computername $Current_Server_IP -credential $Credential
$RemotePerformanceMetricsDir = "D:\TarasolPerfLogs\*" 

Invoke-Command -Session $session    -ScriptBlock { 
Logman stop "TarasolPerfLogs"
Logman stop "ExeptionsPerSecond"

}


Invoke-Command -Session $session  -ArgumentList $Current_Server_IP,$RemotePerformanceMetricsDir  -ScriptBlock {
param($Current_Server_IP,$RemotePerformanceMetricsDir)
Compress-Archive -Path $RemotePerformanceMetricsDir -DestinationPath "D:\Temp\$Current_Server_IP Counters.zip" -Update
}


Write-host "Copy files from $Current_Server_IP to ,Localhost"
Copy-Item "D:\Temp\$Current_Server_IP Counters.zip" -Destination $LocalPerformanceMetricsDir  -FromSession $session
Write-host "Removing files from $Current_Server_IP "
Invoke-Command -Session $session  -ArgumentList $Current_Server_IP,$RemotePerformanceMetricsDir  -ScriptBlock {
param($Current_Server_IP,$RemotePerformanceMetricsDir)
 Remove-Item $RemotePerformanceMetricsDir 
 Remove-Item "D:\Temp\$Current_Server_IP Counters.zip"
}

Remove-PSSession $session

}

Write-Host "---------- Done -------------------" -ForegroundColor yellow 

start-sleep -s 60