#####Author: Robert Polenius Andersson  
####Enable disabled notifications  
###Script is set to enable notifications for Powershell but can be modified to work with any application that are using the Windows Notification framework  
###REQUIREMENTS  
##Modules: PSSQLite  
  
try{  
    ##Database  
    #Import SQLite module  
    Import-Module PSSQLite  
  
    #Set DBPath  
    $DatabasePath = "$env:LOCALAPPDATA\Microsoft\Windows\Notifications\wpndatabase.db"  
  
    #Define select query  
    $SelectQuery = "  
    SELECT HS.HandlerId, HS.SettingKey, HS.Value  
    FROM NotificationHandler AS NH  
    INNER JOIN HandlerSettings AS HS ON NH.RecordId = HS.HandlerID  
    WHERE NH.PrimaryId LIKE '%powershell.exe'  
    AND HS.SettingKey = 's:toast'  
    "  
  
    #Invoke selectquery  
    $NotificationSettings = Invoke-SqliteQuery -DataSource $DatabasePath -Query $SelectQuery  
  
    #If the setting are wrong  
    if($NotificationSettings.Value -ne 1){  
        #Create update query  
        $UpdateQuery = "  
        UPDATE HandlerSettings  
        SET Value = 1  
        WHERE HandlerId = '$($NotificationSettings.HandlerId)' AND SettingKey = 's:toast'  
        "  
        #Invoke updatequery  
        Invoke-SqliteQuery -DataSource $DatabasePath -Query $UpdateQuery  
    }  
  
    ##Registry  
    #Get registry path for application Powershell  
    $RegistryPath = (Get-ChildItem -Recurse -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings" | Where-Object -Property Name -Like '*powershell.exe*' | Select-Object -ExpandProperty Name).Replace('HKEY_CURRENT_USER','HKCU:')  
  
    #Get current value for Enabled  
    $Enabled = Get-ItemProperty -Path $RegistryPath -Name "Enabled" | Select-Object -ExpandProperty Enabled  
  
    #If the value are wrong  
    if($Enabled -ne 1){  
        #Update registry  
        Set-ItemProperty -Path $RegistryPath -Name "Enabled" -Value 1 -Force  
    }  
    return 0  
}catch{  
    $LogFile = "C:\Powershell\Log\PowershellNotifications.log"  
    if(!(Test-Path $LogFile -ErrorAction SilentlyContinue)){  
        New-Item -Path $LogFile  
    }  
    "$(Get-Date) | RemediationScript | ERROR: $($_)" | Out-File $LogFile -Append  
    return $_  
}