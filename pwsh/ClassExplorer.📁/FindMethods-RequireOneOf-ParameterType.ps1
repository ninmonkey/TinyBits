#requires -Version 7
#requires -Modules ClassExplorer

<#
.SYNOPSIS
    This is basically documentation on how you could use ClassExplorer
.LINK
    https://github.com/SeeminglyScience/ClassExplorer/blob/master/docs/en-US/about_Type_Signatures.help.md
#>

Set-Alias 'Fime' -Value 'ClassExplorer\Find-Member' -ea Ignore

function FindMethods-RequireOneOf-ParameterType {
    <#
    .SYNOPSIS
        Require at least one of these parameter types to be present. it can include any others

    .NOTES
        the Original command:
        > [string] | Find-Member -ParameterType { [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]] }
    .EXAMPLE
        [string] | FindMethods-RequireOneOf-ParameterType -ParameterTypeNames 'System.Globalization.CompareOptions','System.String'
    .EXAMPLE
        # You can use strings or [type]
        [string] | [string] | FindMethods-RequireOneOf-ParameterType -ParameterTypeNames ([System.Globalization.CompareInfo], [System.StringComparison])
    .EXAMPLE
        # auto formats verbose tables, grouped on name
        [string] | FindMethods-RequireOneOf-ParameterType -FormatTable -ParameterTypeNames 'System.Globalization.CompareOptions','System.String'
    #>
    [CmdletBinding()]
    param(
        # Names to search for. You can use strings: 'System.String' or typeinfo: [System.StringComparison]
        [Alias('TypeNames')]
        [Parameter(Mandatory)]
        [ArgumentCompletions(
            "'System.String'", "'System.Globalization.CompareOptions'", "'System.StringComparison'"
        )]
        [string[]] $ParameterTypeNames,

        # types, or output from Find-Type/Find-Member
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias('Object')]
        $InputObject,

        # Render table instead of returning objects
        [Alias('ft')]
        [switch] $FormatTable
    )

    begin {
        $ParameterTypeNames | %{
            $tinfo = $_ -as [type]
            if( -not $tinfo ) { 'Type *might* not resolve, but parser might still work: "{0}"' -f ($_)  | Write-warning }
        }
        $query = '[anyof[{0}]]' -f @( $parameterTypeNames | Join-String -sep ', ' )
        $querySB = [scriptblock]::Create( $query )
    }
    end {
        # original: [string] | Find-Member -ParameterType { [anyof[System.String]] } | Ft -AutoSize -Wrap -GroupBy Name
        $found = $InputObject
            | Find-Member -ParameterType $querySB

        if( -not  $FormatTable ) {
            $found
        } else {
            $found | Format-Table -AutoSize -Wrap -GroupBy Name
        }
        "ran query:`n    Find-Member -ParameterType { $query }" | New-Text -fg 'gray80' -bg 'gray40' | Write-Verbose
        # [anyof[System.StringComparer, System.Globalization.CompareOptions, System.StringComparison, System.Collections.Comparer]]
    }
}

    # | ft -GroupBy Name -Property Name, DisplayString

# [string] | FindMethods-RequireOneOf-ParameterType -ParameterTypeNames 'System.StringComparison'
