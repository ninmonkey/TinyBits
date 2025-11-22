#requires -Version 7
#requires -Modules ClassExplorer
<#
.DESCRIPTION
    For a wrapping class, see: <file:///./Get-AmbiguousDateTimeOffset.ps1>
.NOTES
related types:
    [System.DateOnly]
    [System.DateTime]
    [System.DateTimeKind]
    [System.DateTimeOffset]
    [System.Globalization.DateTimeFormatInfo]
    [System.TimeOnly]
    [System.TimeProvider]
    [System.TimeSpan]
    [System.TimeZone]
    [System.TimeZoneInfo]
.LINK
    <file:///./Get-AmbiguousDateTimeOffset.ps1>
.LINK
    <file:///./TimeZoneInfo-Examples.ps1>
#>

$all_sys_zones = [TimeZoneInfo]::GetSystemTimeZones( <# skipSorting #> $false )
$all_sys_zones.count

[TimeZoneInfo]::FindSystemTimeZoneById("Central Standard Time")


# Find array of anything return types
$some = [TimeZoneInfo] | Fime -MemberType Property -Not -RecurseNestedType
$some | fime -ReturnType { [any[]] } | Ft

# find ambiguous methods
[timezoneinfo]|fime -Name '*ambig*' | ft
