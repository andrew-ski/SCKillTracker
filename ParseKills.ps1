$lineCounter = 0
$totalLines = 0
$gameLog = get-content "C:\Users\andrew.zbikowski\Downloads\Game.log"
$totalLines = $gameLog.Length

function Update-Log()
{

$global:gameLog = get-content "C:\Users\andrew.zbikowski\Downloads\Game.log"
$global:totalLines = $gameLog.Length
write-host("Update-Log was called and completed")
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
                 }
            }
        }
write-host("Process-Line was called and completed")
}

function Line-Check{
    
    if($lineCounter -lt $totalLines){

            Process-Line
            }
    else{
        Write-Host("No")
        }
write-host("Line-Check was called and completed")
}
while($True){
    
    Update-Log
    Line-Check
    sleep(5)
}