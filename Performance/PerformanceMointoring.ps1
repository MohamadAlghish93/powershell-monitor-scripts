$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

$counter = 600
 for ($i=1; $i -le $counter; $i++){
"10.51.61.65","10.51.61.66","10.51.61.135","10.51.61.136" | ForEach-Object -Process {

$Current_Server_IP = $_; 


$session = new-pssession -computername $Current_Server_IP -credential $Credential


Invoke-Command -Session $session   -ArgumentList $Current_Server_IP -ScriptBlock {
param($Current_Server_IP)
 Write-Host " "
Write-Host "Server :   $Current_Server_IP    "  -ForegroundColor yellow  
 Write-Host " "

#-------------------------------------------

 $lastbootuptime = Get-CimInstance -ClassName Win32_OperatingSystem | select lastbootuptime
  $lastbootuptime = $lastbootuptime.lastbootuptime
  Write-Host "LastBootUpTime =  " -NoNewLine 
  Write-Host " $lastbootuptime       "  -ForegroundColor Cyan -NoNewLine 

#-------------------------------------------
$Drive = Get-CimInstance -Class Win32_LogicalDisk | Where-Object DeviceID -EQ C:
$FreeRate = [math]::Round( (($Drive.FreeSpace/1gb)/($Drive.Size/1gb)) *100)
$Dsize = [math]::Round($Drive.Size/1gb)
Write-Host "disk C :   " -NoNewLine 
if ( $FreeRate -gt 40 ){
Write-Host "Size =  $Dsize GB  | Free $FreeRate % "  -ForegroundColor Green
}else{
Write-Host "Size =  $Dsize GB  | Free $FreeRate % "  -ForegroundColor Red
}

Write-Host " "
#-------------------------------------------
 
 
$LogsDir = "D:\$Current_Server_IP PerfNVSLogs.txt" 
 $Output = Get-Counter '\Processor(_Total)\% Processor Time' 
 $Readings = $Output.CounterSamples.CookedValue
 $Readings = [math]::Round($Readings)
 $Timestamp = $Output.Timestamp
 "$Timestamp : CPU : $Readings  "| Out-File $LogsDir -Append
 Write-Host "CPU =  " -NoNewLine
 if ($Output.CounterSamples.CookedValue -lt 60 ){
  Write-Host " $Readings %" -ForegroundColor Green  
 }else
 {
  Write-Host " $Readings %" -ForegroundColor Red   
 }

 Write-Host " "
 
 #-------------------------------------------
 $Output = Get-Counter '\Memory\Available MBytes'  
 $MemCap = Get-CimInstance -Class "cim_physicalmemory" | % {$_.Capacity}
 if ($MemCap.Length -gt 1){
   $Vmemory = $MemCap.GetValue(0) 
 }
 else
 {
 $Vmemory = $MemCap 
 }
 $MemCap =  ($Vmemory * $MemCap.Length ) / (1024*1024)
 $Readings = ($MemCap ) - $Output.CounterSamples.CookedValue
 $Timestamp = $Output.Timestamp
  Write-Host "Memory =  " -NoNewLine
  if ($MemCap -gt 81000 ){
    $threshold = 30720
  }else{
   $threshold = 10240
  }
 if ($Readings -lt $threshold ){
  Write-Host " $Readings / $MemCap" -ForegroundColor Green  
 }else
 {
  Write-Host " $Readings / $MemCap" -ForegroundColor Red  
 }
  Write-Host " " 
 "$Timestamp : Memory : $Readings  "| Out-File $LogsDir -Append

#-------------------------------------------
 $Output = (netstat -n | where {$_ -match "\d:80\s"} | measure-object).count 
 $TIME_WAIT =  ( netstat -n | where {$_ -match "\d:80\s"} | where {$_ -match "TIME_WAIT"}).count
 $ESTABLISHED = ( netstat -n | where {$_ -match "\d:80\s"} | where {$_ -match "ESTABLISHED"}).count
 "$Timestamp  : Http Connections : $Output  "| Out-File $LogsDir -Append
  Write-Host "Http Connections :  "  -NoNewLine
if ($Output -lt 500 ){
  Write-Host  " Total = $Output  ESTABLISHED_Http = $ESTABLISHED    TIME_WAIT_Http  = $TIME_WAIT" -ForegroundColor Green  
 }else
 {
  Write-Host  " Total = $Output  ESTABLISHED_Http = $ESTABLISHED    TIME_WAIT_Http  = $TIME_WAIT" -ForegroundColor Red  
 }
  Write-Host " " 
#-------------------------------------------
  
  
 #-------------------------------------------
 $Output = (netstat -n | where {$_ -match "\d:1535\s"} | measure-object).count 
 $TIME_WAIT =  ( netstat -n | where {$_ -match "\d:1535\s"} | where {$_ -match "TIME_WAIT"}).count
 $ESTABLISHED = ( netstat -n | where {$_ -match "\d:1535\s"} | where {$_ -match "ESTABLISHED"}).count
 "$Timestamp  : DB Connections : $Output  "| Out-File $LogsDir -Append
  Write-Host "DB Connections   :  "  -NoNewLine
if ($Output -lt 100 ){
  Write-Host  " Total = $Output  ESTABLISHED_Db   = $ESTABLISHED      TIME_WAIT_Db  = $TIME_WAIT" -ForegroundColor Green  
 }else
 {
  Write-Host  " Total = $Output  ESTABLISHED_Db   = $ESTABLISHED      TIME_WAIT_Db  = $TIME_WAIT" -ForegroundColor Red  
 }
#-------------------------------------------
  
   
  
Write-Host "------------------------------------------------------------------------------- " 
 Write-Host " " 


}
Remove-PSSession $session

}


start-sleep -s 30
clear
}
Write-Host "----------  the script is done  -------------------" -ForegroundColor yellow 
start-sleep -s 60