
function Get-ObjectProperty {
    [Alias('ShortProps')]
    param(
        # filter properties by name using a regex
        [Alias('Regex')]
        [Parameter()]
        [string] $Pattern,

        [Alias('TypeRegex')]
        [string] $TypePattern,

        # Simplify output to only show the more important properties
        [switch] $Basic,

        # If used alone, it's sugar for running "stuff.PSObject.Properties | Sort "
        [switch] $All,

        [Parameter(ValueFromPipeline)] $InputObject
    )
    process {
        $items = $InputObject.PSObject.Properties | Sort-Object Name

        # the logic is fairly simple. Just keep filtering the list if the parameter was used
        if( $All ) { return $items }

        if( $Pattern ) {
            $items = $items | Where-Object { $_.Name -match $pattern }
        }
        if( $TypePattern ) {
            $items = $items | Where-Object { $_.TypeNameOfValue -match $TypePattern }
        }
        if( $Basic ) {
            $items = $items | Select-Object -Prop 'Name', 'TypeNameOfValue', 'Value'
        }
        $items
    }
}

return
# Here's examples to try
$ps = Get-Process
$ps[0] | ShortProps -Basic | Ft  # -Basic removes most of the columns

$file = Get-Item $PSCommandPath

$file | ShortProps -Basic -Pattern 'last' |fl

# Use -Basic to make 'ft' and 'fl' shorter by dropping extra columns
$ps[0] | ShortProps -TypePattern 'Timespan' -Basic |fl

$file | ShortProps -Basic | ft

# find types [timespan] or [int64]
$ps[0] | ShortProps -TypePattern 'Timespan|Int64' |Ft

# find *names* that contain the string '64'
$ps[0] | ShortProps -Pattern 64 |Ft

# What types are used? show type name and counts
$file | ShortProps | Group-Object TypeNameOfValue | ft -AutoSize

Get-process | Get-Random -count 3 | SHortProps -Pattern 'title|commandline|window|name'  -Basic | ft
