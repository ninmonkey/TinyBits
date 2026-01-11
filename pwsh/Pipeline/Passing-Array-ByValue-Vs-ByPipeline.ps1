function SomeFunc {
    <#
    .SYNOPSIS
        Compare processing array byValue vs byPipeline
    .description
        The attribute "AllowNull" allows you to pass null values in the pipeline,
        without errors occurring during "ParameterBinding"

        this is how "Join-String" works
    #>
    [CmdletBinding()]
    param(
        # Objects
        [AllowNull()]
        [Alias('Obj')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]] $InputObject
    )
    process {
        foreach ($cur in $InputObject ) {
            $cur ?? '<null>'
        }
    }
}

$example = $null, 's', $null, 'b'

$example | SomeFunc

SomeFunc -InputObject $example

# optional version
Import-Module 'Mintils' -ea 'stop'

function SomeFuncWithVisual {
    <#
    .SYNOPSIS
        Uses extra Write-Host text to visualize the iterations
    #>
    [CmdletBinding()]
    param(
        [AllowNull()]
        [Alias('Obj')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [object[]] $InputObject
    )
    begin { $numProc = 0; $numFor = 0; }
    process {
        Mint.Write-NL -NumberOfLines 1
        Mint.Write-H1 "numProc: $( ($numProc++) )" -ForegroundColor orange
        foreach ($cur in $InputObject ) {
            Mint.Write-H1 -pad 0 "numFor: $( ($numFor++) )"
            Mint.Write-Label -LabelName 'item' -Value ( $cur ?? '<null>' )
        }
    }
}

# [1] Visualize -Process {} when passing value by pipeline
$example | SomeFuncWithVisual


# [2] Visualize passing [] value as a parameter
SomeFuncWithVisual -InputObject $example
