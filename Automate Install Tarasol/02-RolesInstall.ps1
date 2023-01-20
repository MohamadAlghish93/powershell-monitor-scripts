

echo "Start Install Windows Feature"


Import-Csv "Roles.csv" | foreach{ 
	
	Get-WindowsFeature -Name $_.name | Install-WindowsFeature

}

echo "Finished Install Windows Feature :)"


start-sleep -s 120