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
    - <file:///./Using_JsonEnum.ps1>
    - <file:///./Using_UserDefinedEnums.ps1>
    - <file:///./Using_JsonStringEnumConverter.ps1>

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
function ShowProps {
    [CmdletBinding()]
    param(
        [Alias('Object', 'Target') ]
        [Parameter(ValueFromPipeline, Mandatory)]
        [object] $InputObject,

        [switch] $PassThru
    )

    process {
        if( $PassThru ) { $InputObject.PSObject.Properties | Sort-Object Name }

        $InputObject.PSObject.Properties
            | Sort-Object Name
            | ft -auto Name, TypeNameOfValue, Value
    }
}


enum CloudCoverState {
    Clear
    Partial
    Overcast
}

class CloudCover {
    [DateTimeOffset] $Date
    [Int] $TemperatureCelsius = 0


    [CloudCoverState] $CloudState = 'Partial'
    # [string] $ConsoleColor = 'red'
}

$obj = [CloudCover]::new()
h1 'Obj'
$Obj

h1 'Cmdlet'
$obj | ShowProps
$Obj | ConvertTo-Json -EnumsAsStrings | jq -c

h1 'when using the Cmdlet it either becomes an [Int] or [String], not an [Enum] type'
$obj | ConvertTo-Json
     | ConvertFrom-Json
     | ShowProps

$obj | ConvertTo-Json -EnumsAsStrings
     | ConvertFrom-Json
     | ShowProps

h1 'Serialize( obj, [CloudCover] )'
$json_text = [Text.Json.JsonSerializer]::Serialize( $obj, [CloudCover] )
$json_text | jq -c

$round_trip = [Text.Json.JsonSerializer]::Deserialize( $json_text, [CloudCover] )
$round_trip | ShowProps

h1 'Assert member is of the custom enum type'
$round_trip.CloudState | Should -BeOfType ([CloudCoverState])


<#
next: try <https://learn.microsoft.com/en-us/dotnet/standard/serialization/system-text-json/customize-properties#custom-enum-member-names>
    public class WeatherForecastWithEnumCustomName
    {
        public DateTimeOffset Date { get; set; }
        public int TemperatureCelsius { get; set; }
        public CloudCover? Sky { get; set; }
    }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public enum CloudCover
    {
        Clear,
        [JsonStringEnumMemberName("Partly cloudy")]
        Partial,
        Overcast
    }
    '@ | Write-Host -fg 'blue'
#>
