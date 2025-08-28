using namespace System.Collections.Generic


function Fmt.UL.MinimalDefinition {
    process { $_ | Join-String -f ' - {0}'}
}
function Format-FmtUnorderedList {
    <#
    .synopsis
        Console Unordered List ( aka <ul> )
    .example
        > Fmt.List '
        > Gci . -Directory | % Name | Format-FmtUnorderedList
    #>
    [Alias('Fmt.UL', 'Fmt.List' )]
    param( 
        [Parameter( ValueFromPipeline, Position = 0, Mandatory )]
        [object] $InputObject,

        [Alias('Fg')]
        [object] $Foreground = '#4169e1'
    )
    process { 
        Join-String -f '- {0}' -InputObject $InputObject
            | Write-Host -fg $Foreground
    }
}
function Format-FmtHeader {
    <#
    .synopsis
        Console header ( aka <H1> )
    .example 
        > Fmt.H1 'Section 1'
    .example 
        > Get-Date | Format-FmtHeader -Foreground 'red'
    #>
    [Alias('Fmt.H1')]
    param( 
        [Parameter( ValueFromPipeline, Position = 0, Mandatory )]
        [object] $InputObject,

        [Alias('Fg')]
        [object] $Foreground = '#4169e1'
    )
    process { 
        Join-String -f '## {0}' -InputObject $InputObject
            | Write-Host -fg $Foreground
    }
}
function Format-FmtTableRow {
    <#
    .synopsis
        Console markdown table row ( aka <TR> )
    .example 
    # write a markdown table

        > 'Employee', 'Id', 'Email'   | Format-FmtTableRow
        > '-', '-', '-'               | Format-FmtTableRow
        > 'Jane', '42', 'jane@doe.com' | Format-FmtTableRow

    # Outputs
    
        | Employee | Id | Email |
        | - | - | - |
        | Jane | 42 | jane@doe.com |
    #>
    [Alias('Fmt.TableRow')]
    param( 
        [Alias('Columns', 'Cols')]
        [Parameter( ValueFromPipeline, Position = 0, Mandatory )]
        [object[]] $InputObject

        # [Alias('Fg')]
        # [object] $Foreground = '#4169e1'
    )
    begin {
        [List[Object]] $Columns = @()
    }
    process { 
        $Columns.AddRange( @( $InputObject )) 
    }
    end {
        $Columns | Join-String -f '{0}' -sep ' | ' -op '| ' -os ' |'
            # | Write-Host -fg $Foreground
    }

}
function Format-FmtTable {
    <#
    .synopsis
        Combines several Format-FmtTableRow calls
    .example
        > Format-FmtTable -ColumnName 'Employee', 'Id', 'Email' -Rows @( 
            ,@('Jane', 42, 'jane@doe.com')
            ,@('John', 9, 'john@doe.com') 
        )

    #output
        | Employee | Id | Email |
        | - | - | - |
        | Jane | 42 | jane@doe.com |
        | John | 9 | john@doe.com |
    #>
    param(
        [Alias('InputObject', 'Data')]
        [Parameter(Position = 0, Mandatory)]
        [object[]] $Rows,
        
        [Alias('Header')]
        [Parameter(Position = 1, Mandatory)]
        [string[]] $ColumnName
    )
    $expectedNumCols = $ColumnName.Count
    
    $ColumnName  
        | Format-FmtTableRow
    
    ('-' * $expectedNumCols ).ToCharArray() 
        | Format-FmtTableRow

    foreach( $curRow in $Rows ) {
        if( $curRow.count -ne $expectedNumCols ) {
            @( 

                "Row does not match expected columnCount $expectedNumCols !"
                " Found $( $curRow.count ) instead." 
                'Skipping row... '
            ) | Join-String | Write-Warning
        }
        else {
            $curRow | Format-FmtTableRow
        }
    }
}
