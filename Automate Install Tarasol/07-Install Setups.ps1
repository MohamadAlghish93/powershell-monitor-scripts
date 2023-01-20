echo "Start Install NVSSoft application"


Import-Csv "Setups.csv" | foreach{ 
	
	# echo   "install_$($_.path).log"
    # msiexec /i $_.path /qb! /l*v install.log
    Start-Process -Wait -FilePath msiexec -ArgumentList /i, $_.path, /qb!, /l*v, "install_$($_.name).log"

}

echo "Finished Install NVSSoft application :)"


start-sleep -s 120