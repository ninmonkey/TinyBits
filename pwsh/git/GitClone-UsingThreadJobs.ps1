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

$RootDest = gi -ea 'stop' 'G:\temp\2025-06-30\cloney'


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

if( $true ) {
    # 'always delete some'
    $rmSplat = @{
        Recurse = $true
        Force = $True
        Ea = 'Ignore'
        ProgressAction = 'Ignore'
    }
    rmdir (join-path $RootDest 'Turtle') @rmSplat
    rmdir (join-path $RootDest 'PSSvg') @rmSplat
}
# if( $false -and $true ) {
#     # delete with show progress
#     gci -path $RootDest -Directory | %{ rmdir -Recurse -Force $_ }
#     'delete complete' | Write-host -fg 'goldenrod'
# }

# if($false ) {
#     'delete existing clones' | Write-Host -fg 'orange'
#     $repoList | %{
#         rm -force -recurse (Join-Path $RootDest $_.Dest) <# -ProgressAction silentlyContinue #>

#     }
# }
# rm -force -recurse -Confirm (Join-Path $RootDest 'Pwsh')
# rm -force -recurse -Confirm (Join-Path $RootDest 'regex')
# rm -force -recurse -Confirm (Join-Path $RootDest 'wt')
# PSSvg
# Pwsh
# regex
# wt

$repoList | Join-String Url -f "`n=> {0}"


[List[Object]] $jobs = @()

pushd $RootDest -stack 'clone'

foreach ($repo in $repoList) {
    $jobs += Start-ThreadJob -Name $repo.Dest -ScriptBlock {
        Import-Module Pansies
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
            return
            # return
        }

        # which mode
        git clone $params.Url $params.Dest --quiet
            # | Out-Null

        # git clone $params.Url $params.Dest --verbose # or --progress
            # | Join-String -f "`n       stdout: {0}"
            # | Write-Host -fg 'gray30' -bg 'gray10'



        "finished => {0}" -f @( $params.Dest )
            | Write-Host -fg '#aafebc'

        [Datetime]::now - $startTime
            | Join-String -p TotalMilliseconds -f '    time taken: {0:n0} ms'
            | Write-Host -fg 'goldenrod'

    } -StreamingHost $Host
}
popd -stack 'clone'

        # git clone $params.Url $params.Dest <# --progress #>
        # $out = git clone $params.Url $params.Dest --progress

"Downloads started..." | Write-Host -fg 'gray70'
Wait-Job -Job $jobs | Out-Null

@( foreach ($job in $jobs) {
    Receive-Job -Job $job
} ) | Out-Null

# gci . -Dir

# 'see: $jobs and $repoList'
Get-Variable 'jobs', 'repoList' | ft -auto
