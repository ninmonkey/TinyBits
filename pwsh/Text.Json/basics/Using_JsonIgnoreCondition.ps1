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

.notes
See more:
    - <file:///./Using_JsonEnum.ps1>
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

'To clean up example'
https://gist.github.com/ninmonkey/032df78920dee3370d57b827d841e59e#file-pwshclass-using-text-json-ps1-L43-L63
