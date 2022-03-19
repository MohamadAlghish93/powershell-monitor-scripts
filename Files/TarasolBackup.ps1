Write-Host "----------  Tarasol Backup  -------------------" 

$Source_API = "C:\inetpub\wwwroot\TarasolAPI4\*"
$Source_Site = "C:\inetpub\wwwroot\TarasolSite\*"
$Destination_Backup = "D:\Backup\Tarasol_"+(get-date -f yyyyMMddhhmm)

if (-Not (Test-Path $Destination_Backup )){
       New-Item -Type Directory "$Destination_Backup\API"
	   New-Item -Type Directory "$Destination_Backup\Site"
    }
	 
Copy-Item  $Source_API  "$Destination_Backup\API" -Recurse
Copy-Item  $Source_Site  "$Destination_Backup\Site" -Recurse
Write-Host "----------  done  -------------------" -ForegroundColor yellow 
Start-Sleep -s 300