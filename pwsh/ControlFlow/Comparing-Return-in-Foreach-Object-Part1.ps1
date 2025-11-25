<#
.Synopsis
    Showing almost the same expression using ForEach statement, .ForEach() method, and Foreach-Object cmdlet
.notes

Foreach-Object looks like a regular language loop but it's different.

It's roughly calling function, once per element
    so, 20 elements means 20 function calls

So 'return' statement *really is exiting* the current function scope.

specifies the operation that is performed on each input object. This script block is run for
    every object in the pipeline

## See more:

- ForEach Method: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_arrays?view=powershell-7.6#foreach

- Foreach statement: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_foreach?view=powershell-7.6

- Foreach-Object Cmdlet: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/foreach-object?view=powershell-7.6

- Break statement: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_break?view=powershell-7.6
#>

$nums = 0..6

'Example 1: using foreach statement' | Write-Host -ForegroundColor red

foreach( $x in $nums ) {
    if( $x -lt 3 ) { continue }
    $x
}

'Example 2: using .ForEach() method' | Write-Host -ForegroundColor red

$nums.ForEach({
    if ( $_ -lt 3 ) { return }
    $_
})

'Example 3: using ForEach-Object Cmdlet' | Write-Host -ForegroundColor red

$nums | ForEach-Object {
    if( $_ -lt 3 ) { return }
    $_
}
