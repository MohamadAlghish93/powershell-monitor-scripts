


echo "Start Processing"


$name = Read-Host -Prompt "Please specify the destination folder for the backup "

$DestenationLog = $name + "\bkp_" + (get-date -f yyyyMMddhh)

 if (-Not (Test-Path $DestenationLog )) {
      New-Item -Type Directory $DestenationLog
 }

  Write-Host  $DestenationLog 

$dataColl = @()
Import-Csv "Backup-folder.csv" | foreach { 


    try {
        
        $foldername = $_.name
   $foldeApp = $_.app
   # Get-WindowsFeature -Name $_.name | Install-WindowsFeature
   $foldersize = "{0:N2} MB" -f ((gci –force $_.name –Recurse -ErrorAction SilentlyContinue| measure Length -s).sum / 1Mb)  #(gci $_.name | measure Length -s).sum /  1Gb
   
   $dataObject = New-Object PSObject
   Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldername” -value $foldername
   Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldersizeGb” -value $foldersize

    Write-Host   $_.app " : $foldersize " -ForegroundColor Green

    

    #Zip the Sub-Folder
    Compress-Archive -Path "$foldername" -DestinationPath "$DestenationLog\$foldeApp.zip" 

    Write-Host  "Zip the Sub-Folder $DestenationLog\$foldeApp.zip "  -ForegroundColor Yellow


    $dataColl += $dataObject


    }
    catch {
        # Logging the error to a file
        Write-host -f red "Encountered Error:"$_.Exception.Message
        
    }
	
   
}

# $dataColl | Out-GridView -Title “Size of logs folders”

echo "End Processing"

Start-Sleep 35