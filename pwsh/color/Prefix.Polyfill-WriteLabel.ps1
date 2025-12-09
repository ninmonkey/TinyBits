$global:StringModule_DontInjectJoinString = $true # this matters, because Nop imports the polyfill which breaks code on Join-String:  context/reason: <https://discord.com/channels/180528040881815552/446531919644065804/1181626954185724055> or just delete the module

<# common init #>

Import-Module Pansies -PassThru:$False -DisableNameChecking
Set-Alias -Force -ea 'stop' -Name 'Join-String' -Value Microsoft.PowerShell.Utility\Join-String -PassThru -desc 'Prevent that one module from loading'
    | Out-Null


<# Start 2025-09-22 #>
function Snippet.Prefix {
    [Alias('Prefix')]
    <#
    .SYNOPSIS
        some nicer colors. nin polyfill 2025-09-22
    .EXAMPLE
        Get-date | Prefix modules blue
        Get-date | Prefix modules 'red'
    .EXAMPLE
        (gmo).Name | Prefix tags 'salmon' -Auto | Join-string -sep ', '
    .EXAMPLE
        gmo  | Prefix -name 'stuff' -fg red | Join-string -f "`n => {0}"
    .EXAMPLE
        gmo  | Prefix -name 'stuff' -fg red | Join-string -sep ', ' -op 'modules: '
    .EXAMPLE
        # Old
        Get-Date | Ninmonkey.Console\Write-ConsoleLabel -fg red 'hi'
    #>
    [CmdletBinding()]
    param(
        [Alias('InObj')]
        [Parameter(ValueFromPipeline, Mandatory)]
        $InputObject,

        [Parameter(Position = 1, Mandatory)]
        [Alias('Name', 'Label', 'Key')]
        [string] $Message = 'key: ',

        # Pansies color
        [Parameter(Position = 2)]
        [Alias('Fg')]
        [RgbColor] $ForegroundColor = $Null,
        [Parameter(Position = 3)]
        [Alias('Bg')]
        [RgbColor] $BackgroundColor = $Null,

        # If not set, iterate on values. otherwise uses a join for one line as output.
        [Alias('Join')]
        [Parameter(Position = 4)]
        [string] $Separator,

    # (gmo).Name | Prefix tags 'salmon' -Auto | Join-string -sep ', '
        [Alias('NoAutoBg', 'WithoutAutoBg')]
        [switch] $NoAutoBackgroundColor
    )
    begin {
        [Collections.Generic.List[Object]] $Items = @()
        [switch] $MergeAtEnd = [string]::IsNullOrEmpty( $Separator )

        if( -not $NoAutoBackgroundColor -and ( -not $PSBoundParameters.ContainsKey('BackgroundColor' ) ) )  {
            $BackgroundColor = $ForegroundColor | Pansies\Get-Complement -HighContrast
        }
    }
    process {
        if ( $MergeAtEnd ) {
            $Items.add( $InputObject )
            return
        }
        # if( $Message.Length -gt 0 ) { }
        $InputObject
            | Join-String -f "${Message}{0}"
            | New-Text -Fg $ForegroundColor -Bg $BackgroundColor -Separator $Separator
    }
    end {
        if ( -not $MergeAtEnd ) { return }

        $Items
            | Join-String -f "${Message}{0}" # maybe don't inline
            | New-Text -Fg $ForegroundColor -Bg $BackgroundColor -Separator $Separator

    }
}
# | Join-String -sep ': ' -prop Name, Version -op '::Loading:: ' | Write-Host -fg 'mediumPurple2'
# Import-Module $ModPath -Force -PassThru -  | Join-String -sep ', ' -p { $_.Name, $_.Version }

return
(gmo).Name | Prefix tags 'salmon' -NoAutoBackgroundColor | Join-string -sep ', '
(gmo).Name | Prefix tags 'gray40' | Join-string -sep ', '
(gmo).Name | Prefix tags 'goldenrod' | Join-string -sep ', '
(gmo).Name | Prefix tags 'gray45' 'gray80' | Join-string -sep ', '
(gmo).Name | Prefix tags 'gray90' 'gray35' | Join-string -sep ', '
