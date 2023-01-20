

echo "Start Create Pool IIS"

<#
Import-Csv "Cred.csv" | foreach{ 
	$currentUser = $_.name
	$currentUserPassword = $_.password
}
#>

<#$currentUser = Read-Host 'What is  domain/service account?'
    $pass = Read-Host 'What is  password?' -AsSecureString
    
    $currentUserPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
	#>
	
$cred = Get-Credential #Read credentials
$currentUser = $cred.username
$currentUserPassword = $cred.GetNetworkCredential().password

Import-Module WebAdministration



Import-Csv "PoolsName.csv" | foreach{ 
	
	
	echo IIS:\AppPools\$($_.name)
	New-Item -Path IIS:\AppPools\$($_.name)	
	Set-ItemProperty IIS:\AppPools\$($_.name) -name processModel -value @{userName=$currentUser;password=$currentUserPassword;identitytype=3}

}

echo "End Create Pool IIS :)"

echo "Check Pools"

Get-ChildItem -Path IIS:\AppPools


start-sleep -s 120