Write-Host "----------  Tarasol Backup  -------------------" -ForegroundColor yellow

$Current_Date = (get-date -f yyyyMMddhhmm)
$Destination_Backup = "C:\Backup\Tarasol_$Current_Date"

Import-Csv "backup.csv" | foreach{ 
	
	
	$Dest_folder = $_.name
	$Source_publish = $_.publish
	$Source_Compress =  (get-item $_.publish ).parent.fullname+"\$Dest_folder.zip"
	
    echo $Source_Compress

    # Start-Job -ScriptBlock {
    Compress-Archive -Path  "$Source_publish\*" -DestinationPath $Source_Compress -Update
    # } -Name $Dest_folder

    # Wait-Job -Name $Dest_folder

	Write-Host "Start: $Source_publish"
	
	

	if (-Not (Test-Path "$Destination_Backup\$Dest_folder" )){
		   New-Item -Type Directory "$Destination_Backup\$Dest_folder"		   
	}
		 
	Copy-Item  $Source_Compress  "$Destination_Backup\$Dest_folder" -Recurse -Force
	
    Remove-Item -Path $Source_Compress -Force
	Write-Host "End: $Source_publish"

    Start-Sleep -s 10

}

Write-Host "----------  done  -------------------" -ForegroundColor yellow 


Start-Sleep -s 300