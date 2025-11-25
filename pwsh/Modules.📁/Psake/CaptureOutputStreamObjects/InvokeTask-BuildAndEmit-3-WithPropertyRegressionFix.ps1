$target = Get-Item './BuildAndEmit-3-WithPropertyRegressionFix.ps1'

$return_all = Invoke-psake $target
$final = $return_all | ?{ $_ -isnot [string] }
$final | Ft -AutoSize

'Try: $final, or for the full list, see: $return_all' | Write-Host -fg 'orange'
