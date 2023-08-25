echo "Start Calculate Size log folder"

$dataColl = @()
Import-Csv "Logs.csv" | foreach{ 
	
    $foldername = $_.name
   # Get-WindowsFeature -Name $_.name | Install-WindowsFeature
   $foldersize = "{0:N2} GB" -f ((gci –force $_.name –Recurse -ErrorAction SilentlyContinue| measure Length -s).sum / 1Gb)  #(gci $_.name | measure Length -s).sum / 1Mb
   
   $dataObject = New-Object PSObject
   Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldername” -value $foldername
   Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldersizeGb” -value $foldersize

    # Write-Host   $_.name " : $foldersize " -ForegroundColor Green


    $dataColl += $dataObject
}

$dataColl | Out-GridView -Title “Size of logs folders”

echo "End Calculate Size log folder"