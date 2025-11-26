
$sourceFile = gi '.\PartialOverrideProperties.ps1'
$sourceFile = gi '.\PartialOverrideProperties-part2.ps1'
$error.clear(); $rest = Invoke-psake -buildFile $SourceFile -taskList default
$rest | ?{ $_.PSTypenames -contains @( 'psake.info' ) }
