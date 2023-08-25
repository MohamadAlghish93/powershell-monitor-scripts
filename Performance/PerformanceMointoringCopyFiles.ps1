$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")


$LocalPerformanceMetricsDir = "D:\PerformanceMetrics\" 
if (-Not (Test-Path $LocalPerformanceMetricsDir )) {
  New-Item -Type Directory $LocalPerformanceMetricsDir
}
"10.51.61.65", "10.51.61.66", "10.51.61.135", "10.51.61.136" | ForEach-Object -Process {

  $Current_Server_IP = $_; 

  $session = new-pssession -computername $Current_Server_IP -credential $Credential

  $RemotePerformanceMetricsDir = "D:\$Current_Server_IP PerfNVSLogs.txt" 
  Write-host "Copy files from $Current_Server_IP to ,Localhost"
  Copy-Item -Path  $RemotePerformanceMetricsDir -Destination $LocalPerformanceMetricsDir  -FromSession $session
  Write-host "Removing files from $Current_Server_IP "
  Invoke-Command -Session $session  -ArgumentList $RemotePerformanceMetricsDir  -ScriptBlock {
    param($RemotePerformanceMetricsDir)
    Remove-Item $RemotePerformanceMetricsDir -Force
  }

  Remove-PSSession $session

}

Write-Host "---------- Done -------------------" -ForegroundColor yellow 

start-sleep -s 60