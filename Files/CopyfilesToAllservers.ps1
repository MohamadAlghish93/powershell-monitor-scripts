$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")


#just set the local source and remote Destenation for each server
"10.30.42.96" | ForEach-Object -Process {

$Current_Server_IP = $_;
Write-Host " Copying the files from local to $Current_Server_IP "
$session = new-pssession -computername $Current_Server_IP -credential $Credential


#------------correspondence.js-----------
Copy-Item -Path "D:\26-08-2021\correspondence.js" `
-Destination "C:\inetpub\wwwroot\TarasolSite\Correspondence\javascripts\"  `
-ToSession $session
#------------viewer.js-----------
Copy-Item -Path "D:\26-08-2021\viewer.js" `
-Destination "C:\inetpub\wwwroot\TarasolSite\Correspondence\H5Viewer\js\"  `
-ToSession $session
#-----------TarasolAPI.dll------------
Copy-Item -Path "D:\26-08-2021\TarasolAPI.dll" `
-Destination "C:\inetpub\wwwroot\TarasolAPI4\bin\"  `
-ToSession $session

#-------------TarasolObject.dll ----------
Copy-Item -Path "D:\26-08-2021\TarasolObject.dll" `
-Destination "C:\inetpub\wwwroot\TarasolSite\bin\"  `
-ToSession $session

#--------------TarasolObject.dll---------
Copy-Item -Path "D:\26-08-2021\TarasolObject.dll" `
-Destination "C:\inetpub\wwwroot\TarasolAPI4\bin\"  `
-ToSession $session

#-----------Tarasol.dll------------
Copy-Item -Path "D:\26-08-2021\Tarasol.dll" `
-Destination "C:\inetpub\wwwroot\TarasolAPI4\bin\"  `
-ToSession $session

#-----------TarasolHelper.dll ------------
Copy-Item -Path "D:\26-08-2021\TarasolHelper.dll" `
-Destination "C:\inetpub\wwwroot\TarasolSite\bin\"  `
-ToSession $session

#-----------TarasolHelper.dll ------------
Copy-Item -Path "D:\26-08-2021\TarasolHelper.dll" `
-Destination "C:\inetpub\wwwroot\TarasolAPI4\bin\"  `
-ToSession $session


}

Remove-PSSession $session
Write-Host " Copying the files are done  "
start-sleep -s 120