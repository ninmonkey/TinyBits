using namespace System.Collections.Generic

<#
.Synopsis
    Attempt cloning repos using ThreadJobs
.notes
    You may want to experiment with args like:

        --quiet
        --progress
        --verbose

.link
    https://git-scm.com/docs/git-clone
#>

# Cleanup
$error.clear()
remove-variable 'jobs' -ea ignore
remove-variable 'repoList' -ea ignore

Import-Module Pansies -Global
Import-Module ugit -Global

$Config = @{
    RootDest = gi -ea 'stop' 'G:\temp\cloneTest'
}

# also try: with/without ugit

[List[Object]] $repoList = @(
    @{
        Url = 'https://github.com/PowerShell/PowerShell'
        Dest = 'Pwsh'
    }
    @{
        Url = 'https://github.com/PowerShellWeb/Turtle'
        Dest = 'Turtle'
    }
    @{
        Url = 'https://github.com/microsoft/terminal'
        Dest = 'wt'
    }
    @{
        Url = 'https://github.com/StartAutomating/Irregular'
        Dest = 'regex'
    }
    @{
        Url = 'https://github.com/StartAutomating/PSSvg'
        Dest = 'PSSvg'
    }
)

if( $true ) { # 'always delete some' for testing
    $rmSplat = @{
        Recurse        = $true
        Force          = $True
        Ea             = 'Ignore'
        ProgressAction = 'Ignore'
    }
    rmdir (join-path $Config.RootDest 'Turtle') @rmSplat
    rmdir (join-path $Config.RootDest 'PSSvg') @rmSplat
}

# $repoList | Ft -auto | Out-String
$repoList | Join-String Url -f "`n=> {0}"
    | Write-Host -fg 'gray60'

[List[Object]] $jobs = @()

pushd $Config.RootDest -stack 'clone'

foreach ($repo in $repoList) {
    $jobs += Start-ThreadJob -Name $repo.Dest -ScriptBlock {
        Import-Module Pansies
        Import-Module ugit
        $params = $Using:repo
        $startTime = [Datetime]::Now

        "start => cloning: {0} => {1}" -f @( $params.Url, $params.Dest )
            | Write-Host -fg 'goldenrod'

        # $out = git clone $params.Url $params.Dest
        # $out | Write-Host -fg 'gray60' -bg 'gray30'
        # sleep -sec ( Get-Random -min 2 -max 7)

        if( Test-Path $Params.Dest ) {
            $Params.Url
                | Join-String -f "[skip] Clone already exists: {0}"
                | Write-Host -fg '#aafebc'

            $delta = ( [Datetime]::now ) - $startTime
                #| Join-String -p TotalMilliseconds -f 'time taken: {0:n0} ms'

            $delta
                | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'
                | Write-Host -fg 'goldenrod'

            [pscustomobject]@{
                Status     = 'Exists'
                DurationMs = $delta | Join-String TotalMilliseconds -f '{0:n0}'
                Dest       = $Params.Dest
                Url        = $Params.Url
            }
            return
            # return
        }

        # which mode
        # git clone $params.Url $params.Dest --quiet
        git clone $params.Url $params.Dest # --quiet
            | Join-String -f "  stdout => {0}"
            | New-Text -fg '#f700ff' -bg 'gray20'
            | Write-Host
            # | Out-Null

        # git clone $params.Url $params.Dest --verbose # or --progress
            # | Join-String -f "`n       stdout: {0}"
            # | Write-Host -fg 'gray30' -bg 'gray10'

        "finished => {0}" -f @( $params.Url )
            | Write-Host -fg '#aafebc'

        [Datetime]::now - $startTime
            | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'
            | Write-Host -fg 'goldenrod'

        $deltaStr = [Datetime]::now - $startTime
                | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'

        $deltaStr
            | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'
            | Write-Host -fg 'goldenrod'

        [pscustomobject]@{
            Status = 'Cloned'
            Dest = $Params.Dest
            Url  = $Params.Url
            Time = $deltaStr
        }

    } -StreamingHost $Host
}
popd -stack 'clone'

        # git clone $params.Url $params.Dest <# --progress #>
        # $out = git clone $params.Url $params.Dest --progress

"Downloads started..." | Write-Host -fg 'gray70'
Wait-Job -Job $jobs | Out-Null

return
$finalJobs = @( foreach ($job in $jobs) {
    Receive-Job -Job $job -Keep
} ) # | Out-Null

# gci . -Dir

# 'see: $jobs and $repoList'
Get-Variable 'jobs', 'repoList' | ft -auto


gci -dir -path $Config.RootDest | Ft -auto
