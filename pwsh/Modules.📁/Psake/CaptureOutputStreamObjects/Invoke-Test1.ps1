#requires -Module PSake

$error.clear();

$source1 = gi '.\PartialOverrideProperties.ps1'
$source2 = gi '.\PartialOverrideProperties-part2.ps1'

$Source1.Name | Write-Host -ForegroundColor green
$result1 = Invoke-psake -buildFile $source1 -taskList default
$result1 | ?{ $_.PSTypenames -contains @( 'psake.info' ) } | Ft

"`n------`n"

$Source2.Name | Write-Host -ForegroundColor green
$result2 = Invoke-psake -buildFile $source2 -taskList default
$result2 | ?{ $_.PSTypenames -contains @( 'psake.info' ) } | Ft
