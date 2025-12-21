function GitLog {
    <#
    .synopsis
        logic toggles command line arguments for "git log"
    .example
        > GitLog -Verbose -Paging
        > GitLog -Verbose -NumLogs 10
        > GitLog -Verbose
    #>
    [CmdletBinding()]
    param(
        # I disable pager by default, unless I opt-in to it
        [switch] $Paging,

        # Number of logs, else all
        [int] $NumLogs,

        # Do not run "git". Just build the cli args, show them and quit.
        # This is not a full "ShouldProcess" support
        [Alias('WhatIf')]
        [switch] $TestOnly,

        # Git normally uses the current directory. You can specify one without having to cd.
        [string] $BaseRepoPath
    )

    # prevent aliases and functions from overriding 'git.exe'
    $BinGit = Get-Command -CommandType Application 'git' -ea 'stop'

    if ( $PSBoundParameters.ContainsKey('BaseRepoPath' ) ) {
        # exit early, throw when the filepath is invalid
        $repoRoot = Get-Item -ea 'stop' $BaseRepoPath
    }

    $binArgs = @(
        if ( $RepoRoot ) {
            '-C'
            $repoRoot.FullName
        }

        if ( -not $Paging ) { '--no-pager' }

        'log'

        if ( $numLogs -gt 0 ) { '-n' ; $NumLogs; }

        '--oneline'
    )

    $binArgs | Join-String -op 'calling => git ' -sep ' ' | Write-Verbose
    if ( $TestOnly ) { return }

    & $binGit @binArgs
}

# GitLog -Verbose -Paging
GitLog -Verbose -NumLogs 10

GitLog -Verbose
