

echo "Uninstall NVSSoft application"


Import-Csv "Setups.csv" | foreach{ 
	
    Write-Host "Start Uninstall $($_.setup)" -ForegroundColor Yellow

    Get-Package -Name "$($_.setup)" | Uninstall-Package

    Write-Host "Finished Uninstall $($_.nameapp)" -ForegroundColor Yellow

}

echo "Uninstall NVSSoft application :)"

start-sleep -s 120