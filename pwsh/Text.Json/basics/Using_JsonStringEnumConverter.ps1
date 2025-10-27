#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
using namespace System.Linq

$error.clear()
$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'

<#
.SYNOPSIS
    Convert a class that contains enums to json strings, and back as the original [SomeUser] instances
.notes
    This first part uses existing enum types. A later example uses <Serialization.JsonStringEnumConverter<Type>>

See more:
    - https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/customize-properties#enums-as-strings
    - <file:///./Using_JsonEnum.ps1>
    - <file:///./Using_UserDefinedEnums.ps1>
    - <file:///./Using_JsonStringEnumConverter.ps1>

try:
    [Text.Json.JsonSerializer] | Find-Member Serialize
#>

@(  # Not required, they are used to make example output nicer
    Import-Module ClassExplorer -PassThru
    Import-Module Pester -MinimumVersion 5.1 -PassThru
    Import-Module Pansies -PassThru
) | Join-String -P { $_.Name, $_.Version } -f "- {0}" -sep "`n" | Pansies\Write-Host -fg 'gray40' -bg 'gray20'

function H1 { # not required
    param( [String] $Title = 'Header' )
    "`n## ${Title}" | Pansies\Write-Host -fg Green3
}

class SomeUser {
    <#
    .SYNOPSIS
        A class that has fields of enum types, to attempt round trips
    #>
    [string] $Name = 'anonymous'
    [ConsoleColor] $ColorFg = 'red'
}

# [JsonConverter( [Serialization.JsonStringEnumConverter[System.ConsoleColor]] ) ]
# $enumObj = [System.ConsoleColor]::Gray
# $enumObj | Should -BeOfType ([System.ConsoleColor])

# H1 '[ConsoleColor] to using Serialize( obj, enumType )'
# $result = [Text.Json.JsonSerializer]::Serialize( $enumObj, $enumObj.GetType() )
# $result # out: 7

h1 'ConvertTo-Json Style'
$user = [SomeUser]::new()
$user | ConvertTo-Json -EnumsAsStrings

h1 'ConvertFrom-Json Style'
$round_trip = $user | ConvertTo-Json -EnumsAsStrings | ConvertFrom-Json
$round_trip

h1 'Try Casting to [SomeUser]'
$as_class = [SomeUser] $round_trip
$as_class.GetType
$as_class | Should -BeOfType 'SomeUser' -Because 'Otherwise casting has failed'


get-date | ft -auto
h1 'using Serialize( obj, [SomeUser] )'
# $result = [Text.Json.JsonSerializer]::Serialize( $enumObj, $enumObj.GetType() )
$json_text = [Text.Json.JsonSerializer]::Serialize( $user, $user.GetType() )
$json_text | jq -c

h1 'Try Casting [SomeUser] using PSCO from ConvertFrom-Json'
$round_trip_cmdlet = ( $json_text | ConvertFrom-Json ) -as [SomeUser]
$round_trip_cmdlet

h1 'assert: GetType().Name'
$round_trip_cmdlet | Should -BeOfType ([SomeUser]) -Because 'Otherwise casting has failed'
$round_trip_cmdlet.GetType().Name

h1 'assert: SomeUser.ConsoleColor type'
$round_trip.ColorFg | Should -Be ([ConsoleColor]::Red)
# $round_trip.ColorFg | Should -BeOfType ([ConsoleColor]) -Because 'Expect fail because ConvertFrom-Json Cmdlet did not construct class instance of [SomeUser] atype'# -ea 'Continue'

h1 'assert: is correct after casting ConvertFrom-Json output as [SomeUser] type'
$after_cast = [SomeUser] ( $json_text | ConvertFrom-Json )
$after_cast.ColorFg | SHould -Be ([ConsoleColor]::Red)
$after_cast.ColorFg | SHould -BeOfType ([ConsoleColor])

h1 'Without Cmdlet, Using [Json.JsonSerializer]'
$obj_1 = [Text.Json.JsonSerializer]::Deserialize( $json_text, $user.GetType() )
$obj_2 = [Text.Json.JsonSerializer]::Deserialize( $json_text, [SomeUser] )

# Assert both work
$obj_1 | Should -BeOfType ([SomeUser])
$obj_1.ColorFg | Should -BeOfType ([System.ConsoleColor]) -Because 'Should auto cast into an enum'
$obj_2 | Should -BeOfType ([SomeUser])
$obj_2.ColorFg | Should -BeOfType ([System.ConsoleColor]) -Because 'Should auto cast into an enum'
