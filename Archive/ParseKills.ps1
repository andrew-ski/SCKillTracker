$lineCounter = 0
$totalLines = 0
$filepath = "C:\Program Files\Roberts Space Industries\StarCitizen\LIVE\Game.log"
$gameLog = get-content $filepath
$totalLines = $gameLog.Length
$script:killArray = @()
$script:lineNumArray = @()
$script:newLines = $false

function Update-Log()
{

$script:gameLog = get-content $filepath
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
                $killed = $CharArray[5]
                $killedId = $CharArray[6]
                $killedId = $killedId.Substring(1, $killedId.Length - 2)
                $zone = $CharArray[9]
                $killer = $CharArray[12]
                if($killed.Contains($killedId) -eq $false -and $lineNumArray.Contains($lineCounter) -eq $false){

                   $killLine = "$timestamp | $killer killed $killed | Zone:$zone"
                   #$killLine = "[$linecounter]$killer has slain $killed in $zone at $timestamp"
                   $script:lineNumArray += $lineCounter

                   $script:killArray += $killLine
                   $script:newLines = $true
                 

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
    if($newLines -eq $True){
        clear
        $killArray
        $script:newLines = $false
    }
    #foreach($kline in $killArray){
    #    write-host($kline)
    #}
    sleep(1)
}