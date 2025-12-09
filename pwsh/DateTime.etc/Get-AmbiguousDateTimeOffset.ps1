<#
.NOTES

.LINK
https://learn.microsoft.com/en-us/dotnet/api/system.timezoneinfo.getambiguoustimeoffsets?view=net-10.0#system-timezoneinfo-getambiguoustimeoffsets(system-datetime)
.link
https://github.com/dotnet/dotnet/blob/b0f34d51fccc69fd334253924abd8d6853fad7aa/src/runtime/src/libraries/System.Private.CoreLib/src/System/TimeZoneInfo.cs#L241C13-L290C30
.LINK
    <file:///./Get-AmbiguousDateTimeOffset.ps1>
.LINK
    <file:///./TimeZoneInfo-Examples.ps1>
#>

function TinyBits.Get-TimeZoneInfo {
    <#
    .SYNOPSIS
        Get TimeZoneInfo's for the current machine
    .link
        file:///./readme.md
    #>
    [Alias('Get-TimeZoneInfo')]
    [CmdletBinding()]
    param()

    [TimeZoneInfo]::GetSystemTimeZones( <# skipSorting #> $false )
}

[TimeZoneInfo]::GetSystemTimeZones( <# skipSorting #> $false )
[TimeZoneInfo]::FindSystemTimeZoneById("Central Standard Time")

TinyBits.Get-TimeZoneInfo
