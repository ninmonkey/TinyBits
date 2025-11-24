#requires -Version 7

# gh label list --json color,createdAt,description,id,isDefault,name,updatedAt,url
<#
.Synopsis
    Examples using `gh` github command
.link
    https://cli.github.com/manual
#>

function TinyBits.Gh.Label.List {
    <#
    .synopsis
        Get JSON fields for all labels
    .example
        TinyBits.Gh.Label.List -RepoOwnerName 'PowerShell/PowerShell' -JsonFields 'name', 'color', 'description' -OutputAs PSCO
        TinyBits.Gh.Label.List -RepoOwnerName SeeminglyScience/ClassExplorer
    .example
        # Json, with selected fields
        > TinyBits.Gh.Label.List -RepoOwnerName 'PowerShell/PowerShell' -JsonFields 'color,name,description,isDefault' # | jq
    .example
        # Open repo from cli
        > gh repo view PowerShell/PowerShell --web


    .notes
    Original example:
        gh label list --json color,createdAt,description,id,isDefault,name,updatedAt,url
        gh label list --json 'name' --jq '[ .[] | .name ]' -R PowerShell/PowerShell
        gh repo view --web PowerShell/PowerShell
    #>
    [Alias('Gh.Label.List')]
    param(
        # gh parameter: --repo / -R
         # -R, --repo
         # [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO f1
        [ArgumentCompletions( "'PowerShell/PowerShell'", "'Pansies'") ]
        [string] $RepoOwnerName,

        [string[]] $JsonFields =  ('color,description,id,isDefault,name,url,createdAt,updatedAt'),

        # Output Json or as [PSCO] with properties. ( default: PSCO )
        [Alias('Mode')]
        [ArgumentCompletions( 'Json', 'PSCO')]
        [string] $OutputAs = 'PSCO' # 'Json',

    )
    # [string] $QueryJq = '[ .[] | .name ]'
    [object[]] $binArgs = @(
        'label', 'list',
        '--json', ( $JsonFields -join ',' )
        if( -not [string]::IsNullOrWhiteSpace( $RepoOwnerName ) ) {
            '--repo'
            $RepoOwnerName
        }
        # '--jq', $QueryJq
    )
    'gh.Label.List:: Invoke gh => {0}' -f ( $binArgs -join ' ' )| Write-Verbose -Verbose

    [string[]] $names = @(
        # gh label list --json $fields --jq $QueryJq
        & 'gh' @binArgs
    )
    # | ConvertFrom-Json

    switch( $OutputAs ) {
        'Json' { $names -join "`n" }
        'PSCO' { $names | ConvertFrom-Json }
    }

    # $names | fzf -m
}
