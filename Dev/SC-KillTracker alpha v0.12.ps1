$lineCounter = 0
$totalLines = 0
$script:killArray = @()
$script:lineNumArray = @()
$script:newLines = $false
$runScript = $True
$defaultdirectory = $false
$filepath = "C:\Program Files\Roberts Space Industries\StarCitizen\LIVE\Game.log"

function Set-Directory()
{

    $script:defaultdirectory = Test-Path -Path $filepath
	    if($defaultdirectory){
		    $script:defaultdirectory = $True
	    }
	    else{
            write-host("Paste full path to StarCitizen\LIVE\Game.log WITHOUT quotes and hit ENTER")
		    $script:filepath = read-host("PATH")       
            $testDirectory = Test-Path -Path $filepath
            if($testDirectory){
                $script:defaultdirectory = $True
            }
            else{
                Write-Host("Filepath not valid. Paste full path to Game.log WITHOUT quotes")
                Write-Host("for example: C:\Program Files\Roberts Space Industries\StarCitizen\LIVE\Game.log")
                Set-Directory
                }
	    }
    $gameLog = get-content $filepath
    $totalLines = $gameLog.Length
}

function Update-Log()
{

$script:gameLog = get-content $filepath
$script:totalLines = $gameLog.Length

}

function Process-Line()
{
    foreach($line in $gameLog){
            $lineCounter += 1
            $charArray = $line.Split(" ")
            if($charArray.Length -gt 21 -and $CharArray[3] -eq "Death>"){
                $timeStamp = $CharArray[0].Substring(1, $CharArray[0].Length - 2)
                $timeStamp = Get-Date $timeStamp -Format hh:mm:ss
                $killed = $CharArray[5]
                $killedId = $CharArray[6].Substring(1, $CharArray[6].Length - 2)
                $zone = $CharArray[9]
                $killer = $CharArray[12]
                $weapon = $charArray[17].Substring(0,$charArray[17].Length - 1)
                $damageType = $charArray[21]
                if($killed.Contains($killedId) -eq $false -and $lineNumArray.Contains($lineCounter) -eq $false){
                   $spacingCheck = "$killer killed $killed"
                   if($spacingCheck.Length -le 40){
                       $spaces = 40 - $spacingCheck.Length
                    }
                    else{
                        $spaces = 1
                        }
                   $spacing = " "*$spaces
                   $killLine = "$timestamp | $killer killed $killed $spacing | Weapon:$weapon | Damage: $damageType | Zone:$zone"
                   $script:toastText1 = "$weapon | $damageType | $zone"
                   $script:toastText2 = "$killer killed $killed"

                   #if timestamp is older than 5 minutes, do not toast
                   $ageStamp = $CharArray[0].Substring(1, $CharArray[0].Length - 2)
                   $ageStamp = Get-Date $ageStamp
                   $acceptableAge = (Get-Date).AddMinutes(-5)
                   if($ageStamp -gt $acceptableAge){
                     Toast-up
                   }

                   $script:lineNumArray += $lineCounter
                   $script:killArray += $killLine
 
                   $script:newLines = $true
          
                 }

            }
        }

}

function Line-Check{
    
    if($lineCounter -lt $totalLines){
            Process-Line
        if($newLines -eq $True){
            clear
            $killArray
            $script:newLines = $false
        }
            }
    else{
        Write-Host("No")
        }
#write-host("Line-Check was called and completed")
}

function Toast-up{

    $ToastText01 = [Windows.UI.Notifications.ToastTemplateType, Windows.UI.Notifications, ContentType = WindowsRuntime]::ToastText01
    $TemplateContent = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::GetTemplateContent($ToastText01)
    $TemplateContent.SelectSingleNode('//text[@id="1"]').InnerText = $toastText2
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($toastText1).Show($TemplateContent)
}

while($runScript){
    Set-Directory
    Update-Log
    Line-Check
    sleep(1)
}
