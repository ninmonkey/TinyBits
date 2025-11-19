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

function TinyBits.Gh.Repo.List {
    <#
    .synopsis
        Wraps 'gh repo list ..' with parameters
    .notes
        Original command:
            > gh repo list --source --limit 4 --json ($example_fields -join ',' )

        **Future**:
          - PassThru should use PsTypeName for formatting, and default fields:
          - Date fiels
| ft NameWithOwner, Watchers, updatedAt, url
    .example
        > $static_names = @( 'archivedAt', 'createdAt', 'homepageUrl', 'latestRelease', 'name', 'nameWithOwner', 'pushedAt',
            'sshUrl', 'updatedAt', 'url', 'watchers' )

        > TinyBits.Gh.Repo.List SeeminglyScience -Limit 4 -Source -JsonFields $static_names | jq

    .example
        # save results as objects plus, plus formatting as table
        > ( $found = TinyBits.Gh.Repo.List SeeminglyScience -Limit 4 -Source -JsonFields $static_names -PassThru )
            | ft NameWithOwner, Watchers, updatedAt, url
    .example
        > TinyBits.Gh.Repo.List -Source -Limit 3 -JsonFields 'name', 'nameWithOwner' | ConvertFrom-Json | ft -AutoSize
    .example
        # Find both (archived + fork) for justin:
        > TinyBits.Gh.Repo.List JustinGrote -Archived -Fork
    .LINK
        https://cli.github.com/manual/gh_repo_list
    .LINK
        TinyBits.Gh.Repo.List
    .LINK
        TinyBits.Gh.GetAllJsonFields
    .LINK
        TinyBits.Fzf.Select
    #>
    # [Alias('Gh.Repo.List')]
    [CmdletBinding()]
    param(
        # gh: gh repo list <owner>
        [string] $Owner,

        # If you want a fast response, do not specify '--Json=<csv>', instead use implicit defaults
        # gh: --json
        [Alias('JsonFields')]
        [string[]] $FieldNames,

        # gh: --limit int
        [int] $Limit, # = 30,

        # show only non-forks
        # gh: --source
        [switch] $Source,

        # show only forks
        # gh: --fork
        [switch] $Fork,

        # show only archived
        # gh: --archived
        [switch] $Archived,

        # gh: --visiblity <string>
        [ArgumentCompletions('public', 'private', 'internal' )]
        [string] $Visibility,

        [string] $JqExpression,

        # Should --json queries return as objects rather than json ?
        [Alias('PassThru')]
        [switch] $AsObject,

        # If true, build the command line arguments but don't actually invoke 'gh'. ( Not a real ShouldProcess/WhatIf )
        [Alias('WhatIf')]
        [switch] $TestOnly
    )

    $binGh  = Get-Command 'gh' -CommandType Application -TotalCount 1 -ea 'stop'

    $ghArgs = @(
        # usage: gh repo list [<owner>] [flags]
        'repo', 'list'
        if( -not [string]::IsNullOrWhiteSpace( $Owner ) ) { $Owner }

        if ( $Source ) { '--source' }
        if ( $Fork ) { '--fork' }
        if ( $Archived ) { '--archived' }

        if ( $Limit ) { '--limit', $Limit }

        if( $FieldNames.count -gt 0 ) {
            # also works: if( [string]::IsNullOrWhiteSpace( $constraint_str ) ) { }
            '--json'
            ($fieldNames -join ',')
        }
        if( -not [string]::IsNullOrWhiteSpace( $JqExpression ) ) { '--jq', $JqExpression  }
    )
    $ghArgs | Join-String -sep ' ' -op ' invoke => gh ' | Write-Host -fg 'gray70' -bg 'gray30'
    if( $TestOnly ) { '-TestOnly skipped invoking gh.'  | Write-Verbose ; return; }
    $results = & $binGh @ghArgs

    if( $AsObject ) {
        return $results | ConvertFrom-Json -Depth 9
    }

    return $results
    # $stdout = & $binGh @ghArgs # original: repo list --json *>&1
    # $stdout = & $binGh @ghArgs *>&1

    # gh repo list --source --limit 4 --json ($example_fields -join ',' )
    # gh repo list --source --limit 4 --json ($example_fields -join ',' )

}
function TinyBits.Gh.GetAllJsonFields {
    <#
    .synopsis
        Detect which json fields are valid for each 'gh subcommand --json ...' parameters
    .example
        > TinyBits.Gh.GetAllJsonFields 'repo', 'list'
    .example
        > $selected_names = TinyBits.Gh.GetAllJsonFields 'repo', 'list'
            | TinyBits.Fzf.Select # -Cached

        > gh repo list --source --limit 4 --json ($selected_names -join ',')
    .EXAMPLE
        > $maybeFields = $example_fields -match 'name|url' | Sort-Object
        > TinyBits.Gh.Repo.List JustinGrote -Limit 4 -Source -JsonFields $maybeFields | jq -c
    .LINK
        TinyBits.Gh.Repo.List
    .LINK
        TinyBits.Gh.GetAllJsonFields
    .LINK
        TinyBits.Fzf.Select
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
    .synopsis
        Wraps 'fzf --multi' select command. Optional one key only cached value
    .LINK
        TinyBits.Gh.Repo.List
    .LINK
        TinyBits.Gh.GetAllJsonFields
    .LINK
        TinyBits.Fzf.Select
    #>
    param(
        # Only prompt once, save as cached value. # Future, change to -CachedName [string] to allow multiple cached values based on caller
        [switch] $Cached
    )

    if( $Cached -and $Script:__tinyBitsCache.LastFzfSelect.Count -gt 0  ) {
        return $Script:__tinyBitsCache.LastFzfSelect
    }
    $choices = @( $Input )
    $Selected = $choices | fzf --multi --tac --layout=reverse --gap=1 --gap-line=''
    # do reverse and reverse-list appear the same ?
    $Script:__tinyBitsCache.LastFzfSelect = $Selected
    return $selected
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

# built from command: TinyBits.Gh.GetAllJsonFields -SubCommand 'repo', 'list' |sort-object | join-string -sep ', ' -SingleQuote
$example_fields = @(
    'archivedAt', 'assignableUsers', 'codeOfConduct', 'contactLinks', 'createdAt', 'defaultBranchRef', 'deleteBranchOnMerge', 'description', 'diskUsage', 'forkCount', 'fundingLinks', 'hasDiscussionsEnabled', 'hasIssuesEnabled', 'hasProjectsEnabled', 'hasWikiEnabled', 'homepageUrl', 'id', 'isArchived', 'isBlankIssuesEnabled', 'isEmpty', 'isFork', 'isInOrganization', 'isMirror', 'isPrivate', 'isSecurityPolicyEnabled', 'issues', 'issueTemplates', 'isTemplate', 'isUserConfigurationRepository', 'labels', 'languages', 'latestRelease', 'licenseInfo', 'mentionableUsers', 'mergeCommitAllowed', 'milestones', 'mirrorUrl', 'name', 'nameWithOwner', 'openGraphImageUrl', 'owner', 'parent', 'primaryLanguage',
        # 'projects', 'projectsV2',
        'pullRequests', 'pullRequestTemplates', 'pushedAt', 'rebaseMergeAllowed', 'repositoryTopics', 'securityPolicyUrl', 'squashMergeAllowed', 'sshUrl', 'stargazerCount', 'templateRepository', 'updatedAt', 'url', 'usesCustomOpenGraphImage', 'viewerCanAdminister', 'viewerDefaultCommitEmail', 'viewerDefaultMergeMethod', 'viewerHasStarred', 'viewerPermission', 'viewerPossibleCommitEmails', 'viewerSubscription', 'visibility', 'watchers' )

# exit before Examples
return

$full_list ??= TinyBits.Gh.GetAllJsonFields -SubCommand 'repo', 'list'
$dynamic_names = $full_list -match
     'name|url|owner|date|updated|at' -notmatch
     'security|^owner$|mirrorUrl|openGraphImage' -notmatch
     '^is|template'
     | Sort-Object

TinyBits.Gh.Repo.List JustinGrote -Limit 20 -Source -JsonFields $dynamic_names
    # out: json

TinyBits.Gh.Repo.List JustinGrote -Limit 20 -Source -JsonFields $dynamic_names | ConvertFrom-Json
    # out: PSCustomObject to table


# Examples: Older

$selected_names =
    TinyBits.Gh.GetAllJsonFields 'repo', 'list'
        | TinyBits.Fzf.Select -Cached

gh repo list --source --limit 4 --json ($selected_names -join ',')

$selected_names
    | Join-String -op '$selected_names: ' -sep ', ' -single | Write-Verbose -Verbose


# original script:

$error.clear(); . $dotSrc; $all_fields =  TinyBits.Gh.GetAllJsonFields 'repo', 'list'
$sel = $all_fields | TinyBits.Fzf.Select # -Cached
$sel|sort -p { , @( ($_ -match 'name'), ($_ -match 'url') ) } -Descending
