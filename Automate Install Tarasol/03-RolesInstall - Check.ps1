

echo "Check Install Windows Feature"


Import-Csv "Roles.csv" | foreach{ 
	
	Get-WindowsFeature -Name $_.name | Select-Object Name , InstallState

}

echo "Finished Checked  :)"


start-sleep -s 120