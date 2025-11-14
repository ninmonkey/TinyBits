#requires -PSEdition Core
#requires -Modules ClassExplorer

<#
.SYNOPSIS
    Search for string related methods that allow culture or comparisontypes to be defined
#>

($found = [string] | Fime -ParameterType [string])
$found | Group-Object Name | Sort-Object Name | Join-String -f "`n - {0}" Name

@'
What types to search?
    [CultureInfo]::InvariantCulture.CompareInfo.IsSuffix
    [String]::EndsWith
'@

'## [1] Has any [StringComparison]' | Write-Host -fg 'tomato'
'## [2] Has any [CompareOptions]' | Write-Host -fg 'tomato'
