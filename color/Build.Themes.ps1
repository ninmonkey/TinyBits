using namespace System.Collections.Generic

$BuildConfig = @{
    RepoRoot = ( $RepoRoot = Join-Path $PSScriptRoot '..') | Get-Item -ea 'stop'
    Destination = Join-Path $RepoRoot '/color/palettes.json'
}
$BuildConfig | ft -AutoSize

Set-Alias -ea ignore 'Json' -Value ConvertTo-Json
Set-Alias -ea ignore 'Json.From' -Value ConvertFrom-Json

pushd $PSScriptRoot

function H1 {
    param(
        [Alias('H1')]
        [string] $HeaderName
    )
    $HeaderName
        | Join-String -f "`## {0}"
        | New-Text -fg 'goldenrod' -bg 'gray30'
        | Join-String -f "`n{0}`n"
        | Write-Host
}

function NewThemeColorEntry {
    param(
        [object[]] $Colors
    )
    $out = @(
        '#e6e5e7', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
        '#b6b6d5',
        '#e9e3f1',
        '#757179',
        '#0e0f23'
    )
    $out
}
function NewThemeRecord {
    param(
        [string] $Name = 'none',

        [Parameter(Mandatory)]
        [object[]] $Colors,

        [string[]] $Tags = @(),

        # or metadata hashtable ?
        [string] $About = 'blank'
    )

    return @{
        name   = $Name
        tags   = @()
        guid   = New-Guid
        colors = @( $Colors ) #@#( NewThemeColorEntry )
        about  = $About
    }
}


function WriteAllThemes {
    param(
        [Parameter()]
        [object[]] $Themes
    )
    $json = @{
        about  = 'simple list of color palettes/themes'
        themes = [List[Object]] @( $Themes )
    }

    $json | ConvertTo-Json -depth 5
}


$oneTheme =
    NewThemeRecord -Name 'none' -Tags @('gray') -Colors @(
        '#e6e5e7', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
        '#b6b6d5',
        '#e9e3f1',
        '#757179',
        '#0e0f23'
    ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'


H1 '$OneTheme = '
$oneTheme | Json | Jq


WriteAllThemes -Themes @(
    $oneTheme
)
