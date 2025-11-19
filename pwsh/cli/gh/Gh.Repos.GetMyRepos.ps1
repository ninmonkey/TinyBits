#Requires -Version 7
#Requires -Modules pansies
<#
.Synopsis
    Examples using `gh` github command
.link
    https://cli.github.com/manual
#>
$AppConfig = @{
    MyReposRoot = Get-Item -ea 'stop' 'H:/data/2025/GitRepos.🐒'
}

# if dotsourced, this will preserve caching. Using & operator will start with a clear cache on re-run.
$Script:__tinyBitsCache ??= [ordered]@{
    'LastFzfSelect' = @( )
}

Pushd -stack 'TinyBits.Gh' -ea 'stop' $AppConfig.MyReposRoot
# pwd

function H1 {
    param( [string] $Text )
    "`n"
    "## ${Text}"
        # | Write-Host -fg 'gray60' -bg 'salmon'
        | Write-Host -fg Purple3 -bg (Get-Complement -Color 'Purple3' -HighContrast)
    "`n"
}
function TinyBits.Gh.GetAllJsonFields {
    <#
    .synopsis
        Detect which json fields are valid for each 'gh subcommand --json ...' parameters
    #>
    [OutputType([String[]])]
    [CmdletBinding()]
    param(
        # which 'gh' subcommand ?
        [ArgumentCompletions("'repo', 'list'", "'repo', 'view'")]
        [Alias('Name')]
        [Parameter(Mandatory)]
        [string[]] $SubCommand
    )

    # ex: gh repo list --json *>&1
    $ghArgs = @( $SubCommand, '--json' )
    $binGh  = Get-Command 'gh' -CommandType Application -TotalCount 1 -ea 'stop'
    # $stdout = & $binGh @ghArgs # original: repo list --json *>&1
    $stdout = & $binGh @ghArgs *>&1

    $ghArgs | Join-String -sep ' ' -op ' => ran gh: ' | Write-Host -fg 'gray70' -bg 'gray30'

    # strip ansi, and remove padding margins.
    # Skip firstline or -notmatch 'Specify.*--json'
    $stdout | Select-Object -skip 1 | %{ $_.ToString().Trim() }
}

function TinyBits.Fzf.Select {
    <#

        $Choices | fzf --multi --tac --gap=3 --gap-line='___'
    #>
    param(
        # Only prompt once, save as cached value
        [switch] $Cached
    )

    if( $Cached -and $Script:__tinyBitsCache.LastFzfSelect.Count -gt 0  ) {
        return $Script:__tinyBitsCache.LastFzfSelect
    }

    $choices = @( $Input )
    $Selected = $choices | fzf --multi --tac --layout=reverse --gap=1 --gap-line=''
    # reverse and reverse-list appear the same ?

    $Script:__tinyBitsCache.LastFzfSelect = $Selected

    return $selected



    # $choices | fzf --multi --tac --gap=3 --gap-line='___'
    # [CmdletBinding()]
    # param(
    #     [Parameter(Mandatory, ValueFromPipeline )]
    #     [string[]] $Choices
    # )
    # begin {

    # }
}


# $myRepos = gh repo list --source --limit 999
# # super simple parsing.
# $myRepos.ForEach({ $_ -split '\s+' | Select -First 1 }) | Sort-Object

## raw json property names
<#

    $rawTags was copy pasted from the from command:
        gh repo list --help

    $rawTags = Get-clipboard
    $fields = ($rawTags -join'').ForEach({ $_.trim() }) -split ',\s+' | Sort-Object
#>

$selected_names = TinyBits.Gh.GetAllJsonFields 'repo', 'list' | TinyBits.Fzf.Select -Cached
$selected_names | Join-String -op '$selected_names: ' -sep ', ' -single | Write-Verbose -Verbose

# popd -stack 'TinyBits.Gh' -ea ignore


pwd
