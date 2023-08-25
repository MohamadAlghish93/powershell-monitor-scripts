Function GetStatus ($ServiceName,$URL,$server){

   $Status = wget $URL | % {$_.StatusCode}

   if (($Status -eq "200" ) -or ($Status -eq "204")){

   Write-Host "$server  " -ForegroundColor yellow 
   Write-Host "$ServiceName   ($URL) --> Status : " -NoNewLine
   Write-Host "($Status)" -ForegroundColor Green  
   Write-Host " "
   Write-Host " "
   }


   else{
   Write-Host "$server" -ForegroundColor yellow 
   Write-Host "$ServiceName   ($URL) --> Status :" -NoNewLine
   Write-Host "($Status)" -ForegroundColor Red  
   Write-Host " "
   Write-Host " "
   }

}
#Tarasol Servers
Write-Host "-----------------------Tarasol Servers------------------------------"
Write-Host " "
"10.51.61.65","10.51.61.66","10.51.61.135","10.51.61.136" | ForEach-Object -Process {
   
   GetStatus  "$_"  "http://$_/tarasolsite/login" TarasolSite
   GetStatus  "$_"  "http://$_/tarasolAPI4" TarasolAPI4
   GetStatus  "$_" "http://$_/AMImaging/" AMImaging
   GetStatus  "$_" "http://$_/NVSOTPService/" NVSOTPService
   GetStatus  "$_" "http://$_/Tarasol4WebDav/" Tarasol4WebDav
   GetStatus  "$_" "http://$_/IntegrationCore/" IntegrationCore

}



Write-Host "-----------------------ElasticSearch------------------------------" -ForegroundColor Cyan
Write-Host " "
#ElasticSearch
GetStatus  "172.22.51.70" "http://172.22.51.70:9200/" ElasticSearch



Write-Host "-----------------------Arcmate------------------------------" -ForegroundColor Cyan
Write-Host " "
#Arcmate
"10.51.61.71" | ForEach-Object -Process {

GetStatus  "$_" "http://$_/amws/frmnavigation.aspx" "Arcmate amws"
GetStatus  "$_" "http://$_/amadmin/" "Arcmate AmAdmin"
GetStatus  "$_" "http://$_/amimaging/" "Arcmate AmImaging"
GetStatus  "$_" "http://$_/amwi/" "Arcmate Amwi"
GetStatus  "$_" "http://$_/amservice/" "Arcmate AmService"

}



Write-Host "-----------------------Bots------------------------------" -ForegroundColor Cyan
Write-Host " "
#Bots
GetStatus  "172.22.51.69" "http://10.51.61.67/nvsbotmanager/form/frmLogin.aspx" "Bot Manger" 
"10.51.61.68","10.51.61.69" | ForEach-Object -Process {

   For ($i=0;$i -le 4; $i++){
    if ($i -eq 0){
     GetStatus "$_"  "http://$_/wordconverter/" "Word converter $i" 

    }
     else{
     GetStatus "$_"  "http://$_/wordconverter$i/"  "Word converter $i"
     }

   }

}

Write-Host "--------------------------------------------------------------------" -ForegroundColor Cyan



start-sleep -s 600