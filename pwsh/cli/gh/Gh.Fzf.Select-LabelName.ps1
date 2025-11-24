<#
.Synopsis
    Examples using `gh` github command
.link
    https://cli.github.com/manual
#>

function gh.SelectLabel {
    <#
    .synopsis
    .notes

    Original example:
        gh label list --json 'name' --jq '[ .[] | .name ]' -R PowerShell/PowerShell
    #>
    param(
        # gh parameter: --repo
         # -R, --repo
         # [HOST/]OWNER/REPO   Select another repository using the [HOST/]OWNER/REPO f1
        [string] $RepoOwnerName

    )
    [string] $QueryJq = '[ .[] | .name ]'
    [string] $fields = 'name'

    [object[]] $binArgs = @()
    [string[]] $names = @(
        gh label list --json $fields --jq $QueryJq
    ) | ConvertFrom-Json

    $names | fzf -m
}
