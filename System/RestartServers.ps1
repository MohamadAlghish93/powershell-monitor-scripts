$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name and password.", "", "NetBiosUserName")

Import-Csv "Servers.csv" | foreach { 
    $Current_Server_IP = $_.name;

    $Current_Server_IP  | ForEach-Object -Process {

    

        $session = new-pssession -computername $Current_Server_IP -credential $Credential
    
        Invoke-Command -Session $session   -ScriptBlock {
            Write-Host "Restarting $Current_Server_IP " 
            Restart-Computer -Force
        }
    
        Remove-PSSession $session
    
    }
}


start-sleep -s 120