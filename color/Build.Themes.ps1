using namespace System.Collections.Generic
$error.clear()

$BuildConfig = @{
    RepoRoot = ( $RepoRoot = Join-Path $PSScriptRoot '..') | Get-Item -ea 'stop'
    Destination = (Join-Path $RepoRoot '/color/palettes.json')
    DestinationSimple = (Join-Path $RepoRoot '/color/palettes.simple.json')
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
    # Am I redundant now ?
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [Alias('List', 'Dict', 'Color')]
        [object[]] $ColorList

        # [Parameter(Mandatory, Position = 0, ParameterSetName = 'ByDict')]
        # [Alias('Dict')]
        # [hashtable] $ColorDict
    )
    $ByTextList = @( $ColorList )[0] -is [string]
    if( $ByTextList )  {
        return @(
            $ColorList
        )
    } else {
        return @(
            $ColorDict.GetEnumerator() | ForEach-Object {
                @{
                    name  = $_.Key
                    value = $_.Value
                }
            }
        )
    }
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
        guid   = ( New-Guid ).tostring()
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

    $json #| ConvertTo-Json -depth 5
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

function BuildAllThemes {
    param()
    @(
        NewThemeRecord -Name 'none' -Tags @('blue', 'dim') -Colors @(
            @{ background = '#121212' }
        )

        NewThemeRecord -Name 'none' -Tags @('blue', 'dim') -Colors @(
            '#e6e5e7', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#b6b6d5',
            '#e9e3f1',
            '#757179',
            '#0e0f23'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'

        NewThemeRecord -Name 'none' -Tags @('gray', 'dim') -Colors @(
            '#f0f4f1', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#9da69f',
            '#5d5d56',
            '#c5cdc7',
            '#383b39'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'

        NewThemeRecord -Name 'none' -Tags @('brown', 'dim') -Colors @(
            '#ddddb9', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#b8b3af',
            '#9c7978',
            '#c5b099',
            '#14140d'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'

        NewThemeRecord -Name 'none' -Tags @('purple', 'bold') -Colors @(
            '#dfe0ec', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#757179',
            '#4d274e',
            '#27284e',
            '#170d21'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
        NewThemeRecord -Name 'none' -Tags @('gray', 'dim') -Colors @(
            '#d1d7d7', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#afa9b4',
            '#d7d1d1',
            '#aaafaf',
            '#424341'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
        NewThemeRecord -Name 'none' -Tags @('purple', 'bold') -Colors @(
            '#bab4b8', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#391842',
            '#732f3e',
            '#451938',
            '#200819'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
        NewThemeRecord -Name 'none' -Tags @('gray', 'basic') -Colors @(
            '#ebeaec', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#9d9ba2',
            '#55535b',
            '#3c313d',
            '#18141d'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
        NewThemeRecord -Name 'none' -Tags @('gray', 'ice', 'blue', 'dim', 'dark') -Colors @(
            '#eaedf1', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#bcd1d2',
            '#a2a7a7',
            '#55605b',
            '#1f181c'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
        NewThemeRecord -Name 'none' -Tags @('bold', 'blue') -Colors @(
            '#eff0f9', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#c9ceec',
            '#e1e2e3',
            '#2d3a6e',
            '#051319'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
        NewThemeRecord -Name 'none' -Tags @('green', 'dim', 'earth') -Colors @(
            '#caeecf', # src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design
            '#9bc8b8',
            '#5d796f',
            '#7ca081',
            '#2a3326'
        ) -About 'src: https://bejamas.com/blog/minimalist-color-palette-and-typography-in-web-design'
    )
}
$oneTheme | Json | Jq -Cc
$allThemes = BuildAllThemes
$fullTheme = WriteAllThemes -Themes @(
    $allThemes
)
$FullTheme
    | ConvertTo-Json -depth 5
    | Set-Content -Path $BuildConfig.Destination -Encoding utf8

H1 '$FullTheme = '
gc $BuildConfig.Destination | jq -cC
$BuildConfig.Destination | Join-String -f 'Wrote: "{0}"' | Write-Host -fg 'salmon' -bg 'gray20'



h1 'Jq => simple'
jq '[ .themes[] | { name, guid, colors } ]' $BuildConfig.Destination
    | Set-Content -Path $BuildConfig.DestinationSimple -Encoding utf8

$BuildConfig.DestinationSimple
    | Join-String -f 'Jq Wrote: "{0}"' | Write-Host -fg 'salmon' -bg 'gray20'
