Import-Module 'Pansies'

<#
.description
    Snippet is from from Jaykul: <https://discord.com/channels/180528040881815552/446531919644065804/974503463876698142>
#>

'Hsl', 'Lch', 'Rgb', 'Lab', 'Xyz' |
    Get-Gradient red cyan |
    Get-Complement -AsObject |
    Write-host { 'a'..'z' + 'Z'..'Z' | Get-Random } -no

"`n"

'Hsl', 'Lch', 'Rgb', 'Lab', 'Xyz' |
    Get-Gradient red cyan |
    Get-Complement -AsObject -HighContrast |
    Write-host { 'a'..'z' + 'Z'..'Z' | Get-Random } -no

"`n"

'Hsl', 'Lch', 'Rgb', 'Lab', 'Xyz' |
    Get-Gradient red cyan |
    Get-Complement -AsObject -BlackAndWhite |
    Write-host { 'a'..'z' + 'Z'..'Z' | Get-Random } -no
