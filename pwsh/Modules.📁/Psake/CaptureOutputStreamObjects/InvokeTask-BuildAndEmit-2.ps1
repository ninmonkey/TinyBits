$target = Get-Item './BuildAndEmit-2.ps1'

$return_all = Invoke-psake $target -parameters @{ name = 'Jel' } -properties @{ Last = 'doe' }
$final = $return_all | ?{ $_ -isnot [string] }
$final | Ft -AutoSize

'Try: $final, or for the full list, see: $return_all' | Write-Host -fg 'orange'
# Invoke-psake $target -parameters @{ name = 'Jel'; x = 33 } -properties @{ Last = 'doe'; x = 30 }
