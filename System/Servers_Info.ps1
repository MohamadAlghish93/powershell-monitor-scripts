# Copyright Alghish © NVSSoft 2024



 $Name_File = "ServersInfo_$(get-date -f yyyy-MM-dd).txt"

Import-Csv "Servers.csv" | foreach { 

    $Current_Server_IP = $_.ip;

     

            $Current_Server_IP | ForEach-Object -Process {

            # $Current_Server_IP = $_; 
            # Write-Host "Server :   $Current_Server_IP    "  -ForegroundColor yellow 
            # Write-Host "Server :   $Current_Server_IP    "  -ForegroundColor yello
    

              $Current_Path = (Get-Location).Path 
              
              $fullPath = [System.IO.Path]::Combine($Current_Path, $Name_File)

              "Server :   $Current_Server_IP    " | Out-File  -append -FilePath $fullPath 
              
 
             Invoke-Command    -ArgumentList $Current_Server_IP -ScriptBlock {
                param($Current_Server_IP)

                #Write-Host " "
                Write-Host "Server :   $Current_Server_IP    "  -ForegroundColor yellow  
                #Write-Host " "                

                "OS Version :"  >> $fullPath
                # [System.Environment]::OSVersion.Version | select Major, Build | Out-GridView -Title $Current_Server_IP

                [System.Environment]::OSVersion.Version | select Major, Build | Out-File -append -FilePath $fullPath

                # Get-WmiObject -Class Win32_Product | Where-Object { ($_.name -Like "*Office*") -or ($_.name -Like "*SQL*") -or ($_.name -Like "*VM*") -or ($_.name -Like "*Google*") } | select Name, Version | Out-GridView -Title $Current_Server_IP
        
                "Application version :"  >> $fullPath
                # $creds = get-credential

                Get-WmiObject -Class Win32_Product -ComputerName $Current_Server_IP -credential (get-credential) | Where-Object { ($_.name -Like "*Office*") -or ($_.name -Like "*SQL*") -or ($_.name -Like "*VM*") -or ($_.name -Like "*Google*") } | select Name, Version | Out-File -append -FilePath $fullPath


                "-----------------------------"  >> $fullPath
            }

   

        }

}

[System.Windows.MessageBox]::Show("Done check result $Name_File !", "Result", "OK", "None")