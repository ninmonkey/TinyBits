Add-Type -AssemblyName System.Web
Import-Module ClassExplorer
<#
.SYNOPSIS
    Read urls that have duplicate keys with different values
.LINK
https://learn.microsoft.com/en-us/dotnet/api/system.web.httputility.parsequerystring?view=net-9.0
.LINK
https://github.com/dotnet/runtime/blob/9d5a6a9aa463d6d10b0b0ba6d5982cc82f363dc3/src/libraries/System.Web.HttpUtility/src/System/Web/HttpUtility.cs#L81C77-L81C115
#>

function H1 { param( [string] $Text ) Write-Host -fore Blue "`n## ${Text}`n" }

[uri] $url = 'https://httpbin.org/get?foo=10&cat=jen&robot=bender&cat=kevin&foo=bar'
$parsed = [System.Web.HttpUtility]::ParseQueryString( $url.Query )


h1 'Methods'
Find-Member -InputObject $parsed

h1 'QueryString'
$url.Query

h1 'AllKeys'
$parsed.AllKeys -join ', '

h1 'Get( id | name ) returns a <string>'
$parsed.Get(0)
$parsed.Get('cat')

h1 '.GetValues( id | name ) returns a <list<string>>'
$parsed.GetValues(0) -join ', '
$parsed.GetValues('cat') -join ', '
