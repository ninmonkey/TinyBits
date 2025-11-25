$nums = 0..6

$sb = {
    param( $num )

    "  => called: Sb( ${num} )" | Write-Host -fore Blue
    if( $num -lt 3 ) { return }

    "    => output: ${num}" | Write-Host -fore Green
    $Num
}

'Example 1: using foreach statement' | Write-Host -ForegroundColor red

$nums.ForEach({
    "Enter => .ForEach() method : ${item}" | Write-Host -fore blue

    & $sb $_
})

'Example 2: using .ForEach() method' | Write-Host -ForegroundColor red

foreach( $item in $Nums ) {
    "Enter => Foreach Statement : ${item}" | Write-Host -fore blue
    & $sb $item
}

'Example 3: using ForEach-Object Cmdlet' | Write-Host -ForegroundColor red

$nums | ForEach-Object {
    $item = $_
    "Enter => ForEach Cmdlet: ${item}" | Write-Host -fore blue
    & $sb $item
}
