#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
using namespace System.Linq

$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'

<#
.SYNOPSIS
    Convert an enum [ConsoleColor] to text "7" and back into [ConsoleColor] using [Text.Json.JsonSerializer]
.notes
See more:
    - https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/customize-properties#enums-as-strings
    - <file:///./Using_JsonStringEnumConverter.ps1>
    - <file:///./Using_JsonEnum.ps1>

.example
    [Text.Json.JsonSerializer] | fime Serialize
#>

@(  # Not required, they are used to make example output nicer
    Import-Module ClassExplorer -PassThru
    Import-Module Pester -MinimumVersion 5.1 -PassThru
    Import-Module Pansies -PassThru
) | Join-String -P { $_.Name, $_.Version } -f "- {0}" -sep "`n" | Pansies\Write-Host -fg 'gray40' -bg 'gray20'

function H1 { # not required. Writes Headers to make output more readable.
    param( [String] $Title = 'Header' )
    "`n## ${Title}" | Write-Host -fg Green3
}

$enumObj = [System.ConsoleColor]::Gray
$enumObj | Should -BeOfType ([System.ConsoleColor])

H1 '[ConsoleColor]::Gray to text using: Serialize( obj, enumType )'
$result = [Text.Json.JsonSerializer]::Serialize( $enumObj, $enumObj.GetType() )
$result # out: 7

h1 'Round trip a string back into an [enum]'
$result = [Text.Json.JsonSerializer]::Deserialize( '7', [ConsoleColor] )
$result

$result | Should -BeOfType [ConsoleColor]
$result | Should -Be ([ConsoleColor]::Gray)
