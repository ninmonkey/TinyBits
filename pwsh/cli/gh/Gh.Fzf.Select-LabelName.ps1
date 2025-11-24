<#
.Synopsis
    Examples using `gh` github command
.link
    https://cli.github.com/manual
#>

function gh.SelectLabel {
    <#
    .synopsis

    .example
        gh.SelectLabel -RepoOwnerName SeeminglyScience/ClassExplorer
    .example
        # Open repo from cli
        > gh repo view PowerShell/PowerShell --web

    .notes
    Original example:
        gh label list --json color,createdAt,description,id,isDefault,name,updatedAt,url
        gh label list --json 'name' --jq '[ .[] | .name ]' -R PowerShell/PowerShell
        gh repo view --web PowerShell/PowerShell
    #>
    param(
        # gh parameter: --repo / -R
         # -R, --repo
         # [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO f1
        [string] $RepoOwnerName

    )
    [string] $QueryJq = '[ .[] | .name ]'
    [string] $fields = 'name'

    [object[]] $binArgs = @(
        'label', 'list', '--json', $fields
        if( -not [string]::IsNullOrWhiteSpace( $RepoOwnerName ) ) {
            '--repo'
            $RepoOwnerName
        }
        '--jq', $QueryJq

    )
    'gh.SelectLabel:: Invoke gh => {0}' -f ( $binArgs -join ' ' )| Write-Verbose -Verbose

    [string[]] $names = @(
        # gh label list --json $fields --jq $QueryJq
        & 'gh' @binArgs
    ) | ConvertFrom-Json

    $names | fzf -m
}
