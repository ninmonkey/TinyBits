#requires -Modules Pansies

function Draw-ColorSquare {
    <#
    .notes
    # Taken from the format data
        > $formatData = Get-FormatData -TypeName '*PoshCode*'

    try others
        > $formatViewDef[1].Control.Entries.DisplayEntry.Value 
        > (Get-FormatData -TypeName '*PoshCode*')[1].FormatViewDefinition[0].Control.Headers
        > (Get-FormatData -TypeName '*PoshCode*')[1].FormatViewDefinition[0].Control.Rows.Columns
    #>    
    
    [OutputType( [String] )]
    [CmdletBinding()]
    param(
        [Alias('Color', 'Object')]
        [Parameter( Mandatory, Position = 0, ValueFromPipeline )] 
        [object] $InputObject
    )
    process {
        ( [PoshCode.Pansies.RgbColor] $InputObject ).ToVtEscapeSequence( $true ) + 
        " $( [char] 27 )[0m" +
        ( " #{0:x6}" -f ( [PoshCode.Pansies.RgbColor] $InputObject ).RGB )
    }
}

Fmt.H1 'A'

gci fg: | Get-Random -Count 5 | %{ Draw-ColorSquare -Color $_ }
    | Join-String -f '{0}' -sep ' | ' -op '| ' -os ' |'

Fmt.H1 'B'

    gci fg: | Get-Random -Count 5 | %{ Draw-ColorSquare -Color $_ }

Fmt.H1 'C'

gci fg: | Get-Random -Count 5 | Draw-ColorSquare
| Join-String -f "`n - {0}" -sep '' 


Fmt.H1 'D'

gci fg: | Get-Random -Count 5 | Draw-ColorSquare
| Fmt.UL    

Fmt.H1 'E'


# Gci fg:\ | Get-random -Count 1 | %{ 

#  ([PoshCode.Pansies.RgbColor]$_).ToVtEscapeSequence($true) + " $([char]27)[0m" + ("#{0:X6}" -f ([PoshCode.Pansies.RgbColor]$_).RGB)

# }



gci fg:
    | Get-Random -Count 5 
    | Draw-ColorSquare
    | Join-String -f "'{0}'" -sep ', ' -op 'Colors = [ ' -os ' ] '

<# out:
    Colors = [ '#C1FFC1', '#63B8FF', '#CDCDC1' ] 
#>