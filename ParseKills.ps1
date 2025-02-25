$lineCounter = 0
$totalLines = 0
$gameLog = get-content "C:\Program Files\Roberts Space Industries\StarCitizen\LIVE\Game.log"
$totalLines = $gameLog.Length

function Update-Log()
{

$script:gameLog = get-content "C:\Program Files\Roberts Space Industries\StarCitizen\LIVE\Game.log"
$script:totalLines = $gameLog.Length
#write-host("Update-Log was called and completed")
#write-host("Update-Log: Total Lines = $totalLines")
}

function Process-Line()
{
    foreach($line in $gameLog){
            $lineCounter += 1
            $charArray = $line.Split(" ")
            if($charArray.Length -gt 12 -and $CharArray[3] -eq "Death>"){
                $timeStamp = $CharArray[0]
                $timeStamp = $timeStamp.Substring(1, $timeStamp.Length - 2)
                $timeStamp = Get-Date $timeStamp -Format hh:mm:ss
                $timeStamp = $timeStamp
                $killed = $CharArray[5]
                $killedId = $CharArray[6]
                $killedId = $killedId.Substring(1, $killedId.Length - 2)
                $zone = $CharArray[9]
                $killer = $CharArray[12]
                if($killed.Contains($killedId) -eq $false){
                   Write-Host("[$linecounter]$killer has slain $killed in $zone at $timestamp")
		   $global:gameLog = $null
		   #write-host("Process-Line: TotalLines = $totalLines")
                 }
            }
        }
#write-host("Process-Line was called and completed")
}

function Line-Check{
    
    if($lineCounter -lt $totalLines){

            Process-Line
            }
    else{
        Write-Host("No")
        }
#write-host("Line-Check was called and completed")
}
while($True){
    
    Update-Log
    Line-Check
    sleep(5)
}