#Requires -Version 7
#Requires -Modules pansies
<#
.Synopsis
    Custom git log message templates
.link
    https://git-scm.com/docs/git-grep
.link
    https://git-scm.com/docs/git-log
#>

$AppConfig = @{
    GitRepo = 'H:\github_fork\PowerBI\microsoft📁\DataConnectors'
    Mintils = 'H:\data\2025\GitRepos.🐒\Mintils'
}

filter ParseGitGrepResult {
    <#
    .SYNOPSIS
        returns result as a PSCO
    #>
    param(
    )
    $regex_Name = @'
(?x)
    ^(?<File>.*?)
    :
    (?<Match>.*)
    $
'@
    $regex_Number = @'
(?x)
    ^(?<File>.*?)
    :
    (?<LineNumber>\d+)
    :
    (?<Match>.*)
    $
'@

    if( $_ -match $Regex_Number ) {
        $matches.Remove(0)
        # simple way to enforce property orders without defining types
        return [pscustomobject] $Matches | Select-Object -Prop File, LineNumber, Match
    }
    if( $_ -match $Regex_Name ) {
        $matches.Remove(0)
        return [pscustomobject] $Matches | Select-Object -Prop File, Match
    }
    "Regex pattern failed to match the output for: '${_}'" | Write-Error
}

pushd -ea 'stop' -Stack 'git.demo' -Path $AppConfig.Mintils


'Raw input' | Write-Host -ForegroundColor blue
git --no-pager grep -P -i 'unicode'

'Parsed' | Write-Host -ForegroundColor blue
git --no-pager grep -P -i 'unicode' | ParseGitGrepResult

'Parsed: Numbers' | Write-Host -ForegroundColor blue
git --no-pager grep --line-number -P -i 'unicode' | ParseGitGrepResult

'$Found = git grep ... | Random'
$found = git --no-pager grep --line-number -P -i 'unicode' | ParseGitGrepResult
$found | Get-random -count 5 | ft -AutoSize

popd -ea 'ignore' -Stack 'git.demo'
