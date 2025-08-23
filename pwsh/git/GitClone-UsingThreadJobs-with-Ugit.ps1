using namespace System.Collections.Generic

<#
.Synopsis
    Attempt cloning repos using ThreadJobs
.Description
    This
    - writes streaming status updates to write-host
    - writes object data to output stream, to capture by the caller
.notes
    You may want to experiment with args like:

        --quiet
        --progress
        --verbose

.link
    https://git-scm.com/docs/git-clone
#>

# Cleanup variables to test repeated calls
$error.clear()
remove-variable 'jobs' -ea ignore
remove-variable 'repoList' -ea ignore
remove-variable 'finalJobs' -ea ignore

Import-Module Pansies -Global
Import-Module ugit -Global # optional for the most part

$Config = @{
    RootDest         = Get-Item -ea 'stop' 'G:\temp\cloneTest'
    AlwaysDeleteSome = $true
    StartTime = [Datetime]::Now
    EndTime = $Null
}

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

if( $Config.AlwaysDeleteSome ) { # always delete some for testing
    $rmSplat = @{
        Recurse        = $true
        Force          = $True
        Ea             = 'Ignore'
        ProgressAction = 'Ignore'
    }
    rmdir (join-path $Config.RootDest 'Turtle') @rmSplat
    rmdir (join-path $Config.RootDest 'PSSvg') @rmSplat
}

$repoList | Join-String Url -f "`n=> {0}"
    | Write-Host -fg 'gray60'

[List[Object]] $jobs = @()

Push-Location $Config.RootDest -stack 'clone'

foreach ($repo in $repoList) {
    $jobs += Start-ThreadJob -Name $repo.Dest -ScriptBlock {
        Import-Module Pansies
        Import-Module ugit
        $params    = $Using:repo
        $startTime = [Datetime]::Now

        "start => cloning: {0} => {1}" -f @( $params.Url, $params.Dest )
            | Write-Host -fg 'goldenrod'

        if( Test-Path $Params.Dest ) {
            $Params.Url
                | Join-String -f "[skip] Clone already exists: {0}"
                | Write-Host -fg '#aafebc'

            $delta = [Datetime]::now - $startTime
            $delta
                | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'
                | Write-Host -fg 'goldenrod'

            [pscustomobject]@{
                PSTypeName = 'git.clone.threadjob.result'
                Status     = 'Exists'
                DurationMs = $delta | Join-String TotalMilliseconds -f '{0:n0}'
                Dest       = $Params.Dest
                Url        = $Params.Url
            }
            return
        }

        # git clone $params.Url $params.Dest --quiet
        git clone $params.Url $params.Dest
            | Join-String -f "  stdout: {0}"
            | New-Text -fg '#9b479e'
            | Write-Host
            # | Out-Null

        "finished => {0}" -f @( $params.Url )
            | Write-Host -fg '#aafebc'

        $delta = [Datetime]::now - $startTime
        $delta
            | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'
            | Write-Host -fg 'goldenrod'


        [pscustomobject]@{
            PSTypeName = 'git.clone.threadjob.result'
            Status     = 'Cloned'
            DurationMs = $delta | Join-String TotalMilliseconds -f '{0:n0}'
            Dest       = $Params.Dest
            Url        = $Params.Url
        }
    } -StreamingHost $Host
}
Pop-Location -stack 'clone'

$Config.EndTime = [datetime]::Now

Wait-Job -Job $jobs | Out-Null

$finalJobs = @( foreach ($job in $jobs) {
    Receive-Job -Job $job
} ) # | Out-Null

# 'see: $jobs and $repoList'
$finalJobs | Format-Table -auto

Get-ChildItem -dir -path $Config.RootDest | Format-Table -auto
Get-Variable 'jobs', 'repoList','finalJobs' | Format-Table -auto

($Config.StartTime - $Config.EndTime)
    | Join-String TotalMilliseconds -f 'Total Duration: {0:n0} ms'
    | Write-Host -fg '#aafebc'
