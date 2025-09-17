Import-Module Pansies

# required import
$dotSrc = Get-Item -ea 'stop' ( Join-Path $PSScriptRoot './ArgumentCompleter-For-RgbColor.ps1' )
. (Get-Item -ea 'stop' $DotSrc)

function TestAutoContrast {
    [CmdletBinding()]
    param(
        [int] $Count = 180,
        [int] $HueStep = 10,
        [switch] $HighContrast =  $true,
        [switch] $BlackAndWhite = $false
        # [int] $BrightStep
        # [RgbColor] $Color,
    )

    pansies\Get-ColorWheel -Count $Count -HueStep $HueStep | Foreach-Object {
        $splat_cmpl = @{
            Color         = $_
            HighContrast  = $HighContrast
            BlackAndWhite = $BlackAndWhite
        }
        $autoBg = pansies\Get-Complement @splat_cmpl

        $_.X11ColorName | WriteColor -PassThru  -fg $_ -bg $autoBg
    } | Join-String -sep ' '
}

'Testing names: [ gray00, ..., gray100 ]' | Write-Host

0..99 | ?{ $_ % 3 -eq 0 } | %{
    $name = 'gray{0}' -f $_
     [RgbColor] $cur = $name
     $splat_cmpl = @{
            Color         = $cur
            HighContrast  = $true
            BlackAndWhite = $false
     }
     $autoBg = pansies\Get-Complement @splat_cmpl
     $cur.X11ColorName | WriteColor -PassThru  -fg $cur -bg $autoBg

}| Join-String -sep ' '
