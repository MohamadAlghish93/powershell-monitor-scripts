
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

Import-Csv "Servers.csv" | foreach { 

    $Current_Server_IP = $_.name;
    $Current_Server_IP | ForEach-Object -Process {


        $session = new-pssession -computername $Current_Server_IP -credential $Credential

        Invoke-Command -Session $session  -ArgumentList $Current_Server_IP  -ScriptBlock {
            param($Current_Server_IP)

            Import-Csv "Proceses.csv" | foreach { 
                $ProcessName = $_.name;

                Write-Host	" $ProcessName  $Current_Server_IP " -ForegroundColor yellow  
                Write-Host	" "
                Get-Process -Name $ProcessName
                Write-Host	" "
                Write-Host	"-----------"  -ForegroundColor Cyan

            }

        }
        Remove-PSSession $session


        Write-Host	" "
    }

}

Write-Host	"the script is finished"  -ForegroundColor Green  
start-sleep -s 120