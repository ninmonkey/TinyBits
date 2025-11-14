#requires -PSEdition Core
#requires -Modules ClassExplorer

<#
.SYNOPSIS
    Search for string related methods that allow culture or comparisontypes to be defined
#>
function H1 { $Input | Write-Host -fg 'tomato' }

($found = [string] | Fime -ParameterType [string])
$found | Group-Object Name | Sort-Object Name | Join-String -f "`n - {0}" Name

@'
What types to search?
    [CultureInfo]::InvariantCulture.CompareInfo.IsSuffix
    [String]::EndsWith
'@


'## [1] Has any [StringComparison]' | H1 #| Write-Host -fg 'tomato'

'### [1.A] : from [String]'
[string]
    | fime -Not -RegularExpression '\.ctor|gethash|intern|clone|copyto|length|chars|Empty'
    | fime -ParameterType { [contains[System.StringComparison]] }

'### [1.B] : from [CultureInfo.InvariantCulture].CompareInfo'

[cultureinfo]::InvariantCulture.CompareInfo
    | fime -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] }
    | fime -regex suffix


[cultureinfo]::InvariantCulture.CompareInfo
    | fime -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] }
    # | FIME -Regex 'suffix'


'## [2] Has any [CompareOptions]' | H1 #| Write-Host -fg 'tomato'


'## [3] [String] has either' | H1 #| Write-Host -fg 'tomato'

[string]
    # exclude a bunch we don't care about
    | Find-Member -Not -RegularExpression '\.ctor|gethash|intern|clone|copyto|length|chars|Empty'




'# Syntax Examples' | H1

'## Has [Span[char]]' | H1

[cultureinfo]::InvariantCulture.CompareInfo
    | Find-Member -ParameterType { [contains[char]] }


'## ParameterCount: 3.., and -notmatch "index|sort"' | H1

[cultureinfo]::InvariantCulture.CompareInfo
    | Find-Member -ParameterCount 3..
    | Find-Member -Not -RegularExpression 'index|sort'
    # requires at least one of the params as this type
    | Find-Member -ParameterType { [System.Globalization.CompareOptions] }


    # | Find-Member -ParameterType { [int] } # contains at least one of this type
    # | Find-Member -ParameterType { [anyref] [any] }
    # | Find-Member -ParameterType { [string] }


'## Summarize first method' | H1

$join_func_type = { '{1,20} => as {0}' -f ($_.ReturnType.ToString(), $_.Name) }
[cultureinfo]::InvariantCulture.CompareInfo
    | Find-Member -ParameterType { [contains[char]] }
    | Sort-object -Unique Name
    | Join-String -f "`n {0}" -p $join_func_type


'## Found Version summary' | h1

( $found_funcs = [string]
    | fime -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] } )



'# Short Version' | Write-Host -fg 'purple'



'## [CultureInfo]::InvariantCulture.CompareInfo : IsSuffix/EndsWith' | h1

[cultureinfo]::InvariantCulture.CompareInfo
    | fime -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] }
    | fime -regex 'IsSuffix|EndsWith'
    | ft

'## [String] : IsSuffix/EndsWith' | h1
[string]
    | fime -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] }
    | fime -regex 'IsSuffix|EndsWith'
    | ft


'# Long list includes all methods found' | Write-Host -fg 'purple'

# '## All methods found, expanded list' | h1
[string]
    | fime -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] }
    | ft -GroupBy Name -Property Name, DisplayString
            # or use: | ft -GroupBy Name
