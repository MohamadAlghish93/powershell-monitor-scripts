try
{
	$StartDate = Get-Date
    Write-Host "Start Process" -ForegroundColor Green

    # Credinsal account
    <#$currentUser = Read-Host 'What is  domain/service account?'
    $pass = Read-Host 'What is  password?' -AsSecureString
    
    $currentUserPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))
	#>
	
	$cred = Get-Credential #Read credentials
	$currentUser = $cred.username
	$currentUserPassword = $cred.GetNetworkCredential().password

    # Install Windows Feature
    Write-Host "Start Install Windows Feature" -ForegroundColor Yellow 


    Import-Csv "Roles.csv" | foreach{ 
	
	    Get-WindowsFeature -Name $_.name | Install-WindowsFeature

    }
	
    Write-Host "Finished Install Windows Feature :)" -ForegroundColor Yellow 


    Write-Host "Check Install Windows Feature" -ForegroundColor Magenta


    Import-Csv "Roles.csv" | foreach{ 
	
	    Get-WindowsFeature -Name $_.name | Select-Object Name , InstallState 
       
    }

    Write-Host "Finished Checked  :)" -ForegroundColor Magenta

	
	Write-Host "--------------------" -ForegroundColor Green
	
    Write-Host "Start Create Pool IIS" -ForegroundColor Yellow 

    Import-Module WebAdministration



    Import-Csv "PoolsName.csv" | foreach{ 
	
	
	    echo IIS:\AppPools\$($_.name)
	    New-Item -Path IIS:\AppPools\$($_.name)	
	    Set-ItemProperty IIS:\AppPools\$($_.name) -name processModel -value @{userName=$currentUser;password=$currentUserPassword;identitytype=3}

    } 

    Write-Host "End Create Pool IIS :)" -ForegroundColor Yellow 

    Write-Host "Check Pools" -ForegroundColor Magenta
    Get-ChildItem -Path IIS:\AppPools
    Write-Host "End Checked Pools" -ForegroundColor Magenta
	
	Write-Host "--------------------" -ForegroundColor Green
	
    Write-Host "Start Confguration" -ForegroundColor Yellow 

    Write-Host "System Locale settings" -ForegroundColor Green
    Set-WinSystemLocale ar-AE

    Write-Host "Assigning file access rights to IIS_IUSRS" -ForegroundColor Green
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl = Get-ACL "c:\inetpub\wwwroot"
    $acl.AddAccessRule($accessRule)
    Set-ACL -Path "c:\inetpub\wwwroot" -ACLObject $acl

    Write-Host "End Confguration" -ForegroundColor Yellow 
	
	Write-Host "--------------------" -ForegroundColor Green
    
    Write-Host "Uninstall NVSSoft application" -ForegroundColor Yellow 


    Import-Csv "Setups.csv" | foreach{ 
	
        Write-Host "Start Uninstall $($_.setup)" -ForegroundColor Magenta

        Get-Package -Name "$($_.setup)" | Uninstall-Package

        Write-Host "Finished Uninstall $($_.nameapp)" -ForegroundColor Magenta

    }

    Write-Host "Uninstall NVSSoft application :)" -ForegroundColor Yellow 

    Write-Host "--------------------" -ForegroundColor Green
	
	Write-Host "Start Install NVSSoft application" -ForegroundColor Yellow
	Import-Csv "Setups.csv" | foreach{ 
	
		Start-Process -Wait -FilePath msiexec -ArgumentList /i, $_.path, /qb!, /l*v, "install_$($_.nameapp).log"

	}
	Write-Host "Finished Install NVSSoft application :)" -ForegroundColor Yellow

    Write-Host "--------------------" -ForegroundColor Green
	$EndDate = Get-Date
	$DURATION =  $EndDate - $StartDate
	Write-Host "Execution Time : " + $DURATION.TotalMinutes -ForegroundColor Green
    Write-Host "End :)" -ForegroundColor Green
}
catch
{
   
    Write-Host $_ -ForegroundColor red -BackgroundColor white
}

start-sleep -s 120