#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
using namespace System.Linq

@(
    Import-Module ClassExplorer -PassThru
    Import-Module Pester -MinimumVersion 5.1 -PassThru
    Import-Module Pansies -PassThru
) | Join-String -P { $_.Name, $_.Version } -f "- {0}" -sep "`n" | Pansies\Write-Host -fg 'gray40' -bg 'gray20'

$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'
function H1 {
    param( [String] $Title = 'Header' )
    "`n## ${Title}" | Write-Host -fg Green3
}

[JsonConverter( [Serialization.JsonStringEnumConverter[System.ConsoleColor]] ) ]
$enumObj = [System.ConsoleColor]::Gray
$enumObj | Should -BeOfType ([System.ConsoleColor])

H1 '[ConsoleColor] to using Serialize( obj, enumType )'
$result = [Text.Json.JsonSerializer]::Serialize( $enumObj, $enumObj.GetType() )
$result # out: 7
