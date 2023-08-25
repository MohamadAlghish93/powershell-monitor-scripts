Import-Csv "PoolsName.csv" | foreach { 

    $PoolName = $_.name;

    Write-Host "Start :   $PoolName    "  -ForegroundColor Yellow 
    $pool = Get-IISAppPool -Name $PoolName
    $pool.Recycle()

    $StartTime = (ps -Name w3wp).StartTime

    Write-Host "StartTime :   $StartTime    "  -ForegroundColor Yellow 

    Write-Host "End :   $PoolName    "  -ForegroundColor Green 

}