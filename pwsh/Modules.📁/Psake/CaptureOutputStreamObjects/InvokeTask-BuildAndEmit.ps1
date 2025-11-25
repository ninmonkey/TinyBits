$AppRoot = Get-Item $PSScriptRoot
pushd $AppRoot
# gci . | Ft -auto
# ( $results = Invoke-PSake -buildFile (Join-Path $AppRoot '.\BuildAndEmit.ps1' ) -parameters @{ Name = 'Ted' } )
# $results = Invoke-psake './BuildAndEmit'

@( $results = @(
    $results;
    Invoke-PSake -buildFile (Join-Path $AppRoot '.\BuildAndEmit.ps1' ) -parameters @{ Name = 'Jen' }
    Invoke-PSake -buildFile (Join-Path $AppRoot '.\BuildAndEmit.ps1' ) -parameters @{ Num = 4 }
))  |ConvertTo-Json

'Filter: Not String'
$Results | ?{ $_ -isnot [string] }
$objs = $Results | ?{ $_ -isnot [string] }

$objs  | ft -auto
# $Res appears to always be [string[]]

# return
#   ( $prevOut = Invoke-PSake -buildFile '.\BuildAndEmit.ps1' -parameters @{ Name = 'Ted' } ) ( $prevOut = Invoke-PSake -buildFile '.\BuildAndEmit.ps1' -parameters @{ Name = 'Ted' } )
