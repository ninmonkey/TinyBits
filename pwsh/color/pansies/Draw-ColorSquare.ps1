#requires -Modules Pansies

$OptionalModule = Join-Path $PSScriptRoot 'Formatting-Headers-UnorderedLists-etc.ps1'
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


if( Test-Path $OptionalModule ) {
    . ( Get-Item -ea 'stop' $OptionalModule )
} else { 
    "Skipping examples using optional module: ${OptionalModule}" | Write-Warning
    return
}

Fmt.H1 'Newlines'

gci fg: | Get-Random -Count 5 
    | Draw-ColorSquare

Fmt.H1 'UL'

gci fg: | Get-Random -Count 5 
    | Draw-ColorSquare
    | Join-String -f "`n - {0}" -sep '' 

Fmt.H1 'Quoted list '



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