
function Show-PSReadlineKeyBind {
    <#
    .synopsis
        Sugar to summarize bindings for a user facing message
    .notes
        Runs on PS 5+
    .example
        ShowPSReadlineKeys | Pansies\Write-Host -fg 'gray80' -bg 'gray40'
    .example
        'Set WinPS Keys => ' + ( (ShowPSReadlineKeys) -join ', ' ) | Pansies\Write-Host -fg 'gray60' -bg 'gray20'
    .example
        "${fg:gray60}Set WinPS Keys => ${fg:#4b6987}" + ( (ShowPSReadlineKeys) -join ', ' ) | Pansies\Write-Host -fg 'gray60' -bg 'gray20'
    #>
    [Alias('ShowPSReadlineKeys')]
    param(
        # list of Chords/Key Names to lookup
        [Alias('Name', 'Chord') ]
        [string[]] $KeyNames = ('Tab', 'Enter', 'Alt+Enter', 'Shift+Enter')
    )
    Get-PSReadLineKeyHandler -Bound |
        Where-Object { $_.Key -in $KeyNames } |
        Select-Object Key, Function |
        ForEach-Object { $_.Key, $_.Function -join ': ' }
}
