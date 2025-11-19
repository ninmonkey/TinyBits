#Requires -Version 7
using namespace System.Collections.Generic
using namespace System.Text
using namespace System.Text.Json
using namespace System.Text.Json.Serialization
using namespace System.Linq

$assembly = Add-type -AssemblyName System.Text.Json -PassThru -ea 'stop'

function AutoJson {
    <#
    .SYNOPSIS
        Calls [Text.Json.JsonSerializer] using a pwsh class name
    .notes
        [System.Text.Json.JsonSerializer] has a ton of overloads
    .LINK
        https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializer?view=net-8.0#methods
    #>
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        [Alias('InObj')] [object] $Object,

        # Without a type, it falls back to GetType()
        [Alias('Tinfo')] [type] $TypeInfo
    )
    process {
        if( -not $TypeInfo ) { $TypeInfo = $Object.GetType() }
        [Text.Json.JsonSerializer]::Serialize( <# value: #> $Object, <# tinfo #> $TypeInfo )
        'AutoJson: TryConvert type: {0}' -f $TypeInfo | Write-verbose
    }
}
