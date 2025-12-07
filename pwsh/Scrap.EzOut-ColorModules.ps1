#requires -Module EZOut, Pansies 

Import-Module EZOut

Write-FormatView -TypeName 'System.TimeZoneInfo' -Property Id, DisplayName -AlignProperty @{
    ID = 'Right'
    DisplayName = 'Left'
} -AutoSize |  
        Out-FormatData |
        Push-FormatData
    
Get-TimeZone

$cmds = gcm -Name *dotil*, *mint*
$cmds