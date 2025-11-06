#Requires -Version 7
#Requires -Modules pansies
<#
.Synopsis
    Custom git log message templates
.link
    https://git-scm.com/docs/git-log
.link
    https://git-scm.com/docs/git-shortlog
.link
    https://git-scm.com/docs/git-log#Documentation/git-log.txt-n
.link
    https://git-scm.com/docs/git-log#Documentation/git-log.txt-decorateoption
.link
    https://git-scm.com/docs/git-log#Documentation/git-log.txt-describeoption

#>
$AppConfig = @{
    GitRepo = 'H:\github_fork\PowerBI\microsoft📁\DataConnectors'
}

Pushd -ea 'stop' $AppConfig.GitRepo
# pwd

function H1 {
    param( [string] $Text )
    "`n"
    "## ${Text}"
        # | Write-Host -fg 'gray60' -bg 'salmon'
        | Write-Host -fg Purple3 -bg (Get-Complement -Color 'Purple3' -HighContrast)
    "`n"
}
function NewGitFormat {
    <#
    .Synopsis
        Build a format string for git log '--pretty=format:...'
    .NOTES
        This auto-converts newlines to %n

        newline = %n
    .example
        > NewGitFormat -Segments @( 'parent: %p', "`n", 'hash: %h', "`n`n" )
    .example
        > git log -n 3 (NewGitFormat -Segments @( 'parent: %p', "`n", 'hash: %h', "`n`n" ))
    .example
        > git log (NewGitFormat "%p`n%h`n`n") -n 3
    #>
    [OutputType( [string] )]
    param(
        [string[]] $Segments
    )
    [string] $Format = $Segments | Join-String -sep '' -op '--pretty=format:'
    $format = $format -replace "`n", '%n'
    return $Format
}

# ' | out-Host' is used to prevent paging
h1 'Ex: 1'
git log '--pretty=format:%nparent: %p%nhash: %h' -n 3 | Out-Host
git log -n 3 (NewGitFormat -Segments @( 'parent: %p', "`n", 'hash: %h', "`n`n" )) | Out-Host

h1 'Comparing --date=<fmt>'
foreach( $fmt in 'relative', 'local', 'iso-strict', 'rfc', 'short', 'raw', 'default-local' ) {
    h1 $fmt
        git log `
        "--date=${fmt}" `
        -n 1 `
        --pretty=medium --abbrev-commit --abbrev=3 <# --shortstat #> `
        --color=always | out-host
}

h1 'Ex: Decent default: oneline, abbrev-commit, shortstat'
git log -n 5 --pretty=oneline --abbrev-commit --shortstat --color=always | out-host

h1 'Ex: ShortStat and "oneline"'
git log -n 5 --pretty=oneline --shortstat

h1 'Ex: --abbrev-commit'
git log --pretty=oneline -n 5 --abbrev-commit

h1 'Ex: --abbrev-commit and --abbrev=3'
git log --pretty=oneline -n 5 --abbrev-commit --abbrev=3

h1 'Ex: --shortstat'
git log --pretty=oneline -n 7 --abbrev-commit --abbrev=3 --shortstat


h1 'Done'

return
# examples dump

git log '--pretty=format:%nparent: %p%nhash: %h'                        `
    -n 4 --color=always | Out-host #--color=always | write-host

git log '--pretty=format:%nparent: %p%nhash: %h'                        `
    -n 4 --color=always | Out-host #--color=always | write-host

# The dreaded line escape
git `
  log             `
  --abbrev=3 `
  --pretty=oneline `
  -n 10 `
  --color=always| out-host

git log `
  -n 10 `
  --pretty=oneline --abbrev-commit --abbrev=3 --shortstat `
  --color=always | out-host
