#get-item wsman:\localhost\Client\TrustedHosts
#Enable-PSRemoting -Force
#Set-Item wsman:\localhost\client\trustedhosts "10.51.61.65,10.51.61.66,10.51.61.135,10.51.61.136,10.51.61.67"
#Restart-Service WinRM
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
$Number_Of_Days = 1;
$API_Logs_Remote = "C:\inetpub\wwwroot\TarasolAPI4\Correspondence\TarasolSetting\Logs"
$Site_Logs_Remote = "C:\inetpub\wwwroot\TarasolSite\Correspondence\TarasolSetting\Logs"
$IIS_Logs_Remote = "C:\inetpub\logs\LogFiles\W3SVC1"
$AMI_Logs_Remote = "C:\inetpub\wwwroot\AMImaging\Logs"
$Bot_Logs_Remote = "C:\inetpub\wwwroot\nvsbotmanager\Logs"
$TempDestination = "D:\Temp"
$Destenation = "D:\NVSLogs_" + (get-date -f yyyyMMddhhmm)
#--------------------------------------------------
$Tarasol_App1 = '10.51.61.65'
$Tarasol_App2 = '10.51.61.66'
$Tarasol_App3 = '10.51.61.135'
$Tarasol_App4 = '10.51.61.136'
$Bot_Manger = '10.51.61.67'
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

$counter = 1;
$Tarasol_App1, $Tarasol_App2, $Tarasol_App3, $Tarasol_App4, $Bot_Manger | ForEach-Object -Process {

  $Current_Server_IP = $_;

  if (($Current_Server_IP -eq $Bot_Manger)) {

    $BotDIR_Des = "$Destenation\Bot_S$counter\Bot\"
    if (-Not (Test-Path $BotDIR_Des )) {
      New-Item -Type Directory $BotDIR_Des
    }
    $EventViewer_Des = "$Destenation\Bot_S$counter\Events\"
    if (-Not (Test-Path $EventViewer_Des )) {
      New-Item -Type Directory $EventViewer_Des
    }
		
    $IISDIR_Des = "$Destenation\Bot_S$counter\IIS\"
    if (-Not (Test-Path $IISDIR_Des )) {
      New-Item -Type Directory $IISDIR_Des
    }
  }
  else {
    $APIDIR_Des = "$Destenation\App_S$counter\API\"
    if (-Not (Test-Path $APIDIR_Des )) {
      New-Item -Type Directory $APIDIR_Des 
    }

    $SITEDIR_Des = "$Destenation\App_S$counter\SITE\"
    if (-Not (Test-Path $SITEDIR_Des )) {
      New-Item -Type Directory $SITEDIR_Des 
    }

    $IISDIR_Des = "$Destenation\App_S$counter\IIS\"
    if (-Not (Test-Path $IISDIR_Des )) {
      New-Item -Type Directory $IISDIR_Des
    }

    $AMIDIR_Des = "$Destenation\App_S$counter\AMI\"
    if (-Not (Test-Path $AMIDIR_Des )) {
      New-Item -Type Directory $AMIDIR_Des
    }

		
    $EventViewer_Des = "$Destenation\App_S$counter\Events\"
    if (-Not (Test-Path $EventViewer_Des )) {
      New-Item -Type Directory $EventViewer_Des
    }
		
  }

        
		
		
  $session = new-pssession -computername $Current_Server_IP -credential $Credential
  Invoke-Command -Session $session -ArgumentList $Bot_Manger, $EventViewer_Des, $Current_Server_IP, $Bot_Logs_Remote `
    , $AMI_Logs_Remote, $Number_Of_Days, $API_Logs_Remote, $Site_Logs_Remote, $IIS_Logs_Remote `
    , $TempDestination -ScriptBlock {
    param($Bot_Manger, $EventViewer_Des, $Current_Server_IP, $Bot_Logs_Remote, $AMI_Logs_Remote `
        , $Number_Of_Days, $API_Logs_Remote, $Site_Logs_Remote, $IIS_Logs_Remote, $TempDestination)

    function PrepareLosFiles($RemoteLocation, $TempDestination, $Number_Of_Days) {
      Write-Host "PrepareLosFiles ----"
      Get-ChildItem $RemoteLocation `
    | Where-Object { $_.LastWriteTime -gt (Get-Date).AddDays(-$Number_Of_Days) } `
    | ForEach-Object { Copy-Item -Path $RemoteLocation\$_ -Destination $TempDestination }

    }
    function EventViewerLogs($EventPath) {
    	 $logFile = Get-WmiObject Win32_NTEventlogfile | Where-Object { $_.logfilename -eq "Application" }
      $logFile.BackupEventlog("$EventPath\Application_Events_" + (get-date -f yyyyMMdd) + ".evt")
      $logFile = Get-WmiObject Win32_NTEventlogfile | Where-Object { $_.logfilename -eq "System" }
      $logFile.BackupEventlog("$EventPath\System_Events_" + (get-date -f yyyyMMdd) + ".evt")
    }

 
 
    if (-Not (Test-Path "$TempDestination\API\" )) { 
      New-Item -Type Directory "$TempDestination\API\"
    }
    if (-Not (Test-Path "$TempDestination\Site\" )) {
      New-Item -Type Directory "$TempDestination\Site\"
    }
    if (-Not (Test-Path "$TempDestination\IIS\"  )) {
      New-Item -Type Directory "$TempDestination\IIS\"
    }
    if (-Not (Test-Path "$TempDestination\AMI\"  )) {
      New-Item -Type Directory "$TempDestination\AMI\"
    }
    if (-Not (Test-Path "$TempDestination\EventViewer\"  )) {
      New-Item -Type Directory "$TempDestination\EventViewer\"
    }
    if ( -Not(Test-Path "$TempDestination\Bot\")) {
      New-Item -Type Directory "$TempDestination\Bot\"
    }

	 
	 
	 
    if (($Current_Server_IP -eq $Bot_Manger)) {
      PrepareLosFiles -RemoteLocation $Bot_Logs_Remote -TempDestination "$TempDestination\Bot\"    -Number_Of_Days $Number_Of_Days
    }
    else {
      write-host "lololol $Current_Server_IP   $Bot_Manger" 
      PrepareLosFiles -RemoteLocation $API_Logs_Remote -TempDestination "$TempDestination\API\"    -Number_Of_Days $Number_Of_Days
      PrepareLosFiles -RemoteLocation $Site_Logs_Remote -TempDestination "$TempDestination\Site\"  -Number_Of_Days $Number_Of_Days
      PrepareLosFiles -RemoteLocation $AMI_Logs_Remote -TempDestination "$TempDestination\AMI\"    -Number_Of_Days $Number_Of_Days
    }

    #for all Servers
    #--------------------------
    PrepareLosFiles -RemoteLocation $IIS_Logs_Remote -TempDestination "$TempDestination\IIS\"    -Number_Of_Days $Number_Of_Days
    #get the EventViewer logs
    EventViewerLogs -EventPath "$TempDestination\EventViewer"
    #--------------------------
  }
  write-host "-------------------" 
  write-host " getting the files from server  $Current_Server_IP " 
  write-host "-------------------" 

  if (($Current_Server_IP -eq $Bot_Manger)) {
    Copy-Item -Path "$TempDestination\Bot\*"  -Destination $BotDIR_Des  -FromSession $session
  }
  else {

    Copy-Item -Path "$TempDestination\API\*"  -Destination $APIDIR_Des  -FromSession $session
    Copy-Item -Path "$TempDestination\Site\*" -Destination $SITEDIR_Des -FromSession $session
    Copy-Item -Path "$TempDestination\AMI\*"  -Destination $AMIDIR_Des  -FromSession $session
  }

  #for all Servers
  #--------------------------
  Copy-Item -Path "$TempDestination\IIS\*"  -Destination $IISDIR_Des  -FromSession $session
  Copy-Item -Path "$TempDestination\EventViewer\*"  -Destination $EventViewer_Des  -FromSession $session
  #--------------------------


  Remove-PSSession $session
  $counter = $counter + 1;

}



$Tarasol_App1, $Tarasol_App2, $Tarasol_App3, $Tarasol_App4, $Bot_Manger | ForEach-Object -Process {

  $Current_Server_IP = $_;
  $session = new-pssession -computername $Current_Server_IP -credential $Credential
  write-host "-------------------" 
  write-host "remove temp files in server $Current_Server_IP at  $TempDestination"
  write-host "-------------------" 
  Invoke-Command -Session $session  -ArgumentList $TempDestination  -ScriptBlock {
    param($TempDestination )
    Remove-Item "$TempDestination\*" -Force
  }
  Remove-PSSession $session
}
write-host "-------collecting logs is done --" 
start-sleep -s 60
