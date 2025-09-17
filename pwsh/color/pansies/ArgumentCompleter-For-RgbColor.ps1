Import-Module Pansies
<#
.SYNOPSIS
    Add Color completions using Pansies
.notes
    Taken from: https://github.com/PoshCode/Pansies/blob/448454654f2b722932623564e48431831c9aaaab/Source/Private/_init.ps1#L73-L88
.EXAMPLE

    # Try partial names like:

        > WriteColor -FgColor b<tab>
#>

# Enable extra colors:
[PoshCode.Pansies.RgbColor]::ColorMode = 'Rgb24Bit'
$Now = Get-Date

function WriteColor {
    <#
    .SYNOPSIS
        Complete and write both
    #>
   [cmdletBinding()]
   param(
        [PoshCode.Pansies.RgbColor] $FgColor = 'gray60',
        [PoshCode.Pansies.RgbColor] $BgColor = 'gray30',

        [Parameter( ValueFromPipeline )]
        [Alias('Text')]
        $InputObject,

        [switch] $PassThrud
    )
    process {
        if( $PassThru ) {
            $InputObject | Pansies\New-Text -fg $FgColor -bg $BgColor
            return
        }
        $InputObject
            | Pansies\New-Text -fg $FgColor -bg $BgColor
            | Join-String -f '    {0}'
            | Pansies\Write-Host
    }
}


Register-ArgumentCompleter -CommandName 'WriteColor' -ParameterName 'FgColor' -ScriptBlock $RgbColorCompleter
Register-ArgumentCompleter -CommandName 'WriteColor' -ParameterName 'BgColor' -ScriptBlock $RgbColorCompleter

$now | WriteColor black goldenrod
$now | WriteColor -Fg gray20 -Bg gray50
$now | WriteColor
$now | WriteColor -Bg gray20 -Fg gray50
$now = Get-Date

$prevDt = $now
$now    = Get-Date
'Elapsed: {0:n2} ms' -f ($now - $prevDt).TotalMilliseconds | WriteColor
