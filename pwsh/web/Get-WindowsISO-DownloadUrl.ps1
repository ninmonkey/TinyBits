#Requires -PSEdition Core
#requires -Modules PSParseHtml, Pansies
<#
.DESCRIPTION
This blog post came up in discord, a user looking for the ISO Download
    blog: <https://powershellisfun.com/2022/05/25/get-all-download-links-from-microsoft-evaluation-center/>
    context: <https://discord.com/channels/180528040881815552/447476117629304853/1449285336503943259>

It uses Invoke-WebRequest basic parsing.
Here's how to use PSParseHtml instead, for real CSS Selector queries and filters.

Since they require ps7 anyway, you can use null coalescing operators
#>
$script:cache ??= @{}
filter _ParseSimple {
    <#
    .synopsis
        Transform the <a> element, grabbing useful properties. dropping extras.
    #>
    $elem = $_
    $info = [ordered]@{
        Is64Bit    = $elem.TextContent -match '64-bit'
        IsEnglish  = $null
        BiLinkName = $null
        Label      = $elem.Attributes['aria-label'].Value
        Text       = $elem.TextContent
        Link       = $elem.Href
        Id         = $elem.Attributes['id'].Value
        BiTags     = $elem.Dataset['bi-tags'] | ConvertFrom-Json
        ClassList  = $elem.ClassList
    }
    $info.IsEnglish  = $info.Label -match 'english'
    $info.BiLinkName = $info.BiTags.BiLinkName

    [pscustomobject]$Info
}

function TryFindDownloadUrl {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
            [uri] $Href,

        [Alias('CssQuery')]
            [ArgumentCompletions(
                "'a[aria-label~=""download""]'",
                "'[aria-label~=""download""]'",
                "'.link-group a'" )]
            [string] $QuerySelector = '[aria-label~="download"]',

        # Don't do the final filtering, let the user do it
        [switch] $PassThru
    )
    # super minimal cache since it's pwsh7
    $Href | Join-String -f '   fetch: {0}' | Pansies\Write-Host -fg gray60 -bg gray30

    $uriKey = $Href.ToString()
    $script:cache[ $uriKey ] ??= PsParseHtml\ConvertFrom-HTML -Url $Href -Engine AngleSharp
    $resp   = $cache[ $uriKey ]

    if( $null -eq $resp ) {
        "TryFindDownloadUrl: Error with Url: ${Href}" | Write-Warning
        return
    }

    $basic  = $resp.QuerySelectorAll( $QuerySelector )
    $parsed = $basic | _ParseSimple

    if( $PassThru ) { return $parsed }
    $parsed | ? Is64Bit | ? IsEnglish
}

[uri[]] $urls = @(
    'https://www.microsoft.com/en-us/evalcenter/download-biztalk-server-2016',
    'https://www.microsoft.com/en-us/evalcenter/download-host-integration-server-2020',
    'https://www.microsoft.com/en-us/evalcenter/download-hyper-v-server-2016',
    'https://www.microsoft.com/en-us/evalcenter/download-hyper-v-server-2019',
    'https://www.microsoft.com/en-us/evalcenter/download-lab-kit',
    'https://www.microsoft.com/en-us/evalcenter/download-mem-evaluation-lab-kit',
    'https://www.microsoft.com/en-us/evalcenter/download-microsoft-endpoint-configuration-manager',
    'https://www.microsoft.com/en-us/evalcenter/download-microsoft-endpoint-configuration-manager-technical-preview',
    'https://www.microsoft.com/en-us/evalcenter/download-microsoft-identity-manager-2016',
    'https://www.microsoft.com/en-us/evalcenter/download-sharepoint-server-2013',
    'https://www.microsoft.com/en-us/evalcenter/download-sharepoint-server-2016',
    'https://www.microsoft.com/en-us/evalcenter/download-sharepoint-server-2019',
    'https://www.microsoft.com/en-us/evalcenter/download-skype-business-server-2019',
    'https://www.microsoft.com/en-us/evalcenter/download-sql-server-2016',
    'https://www.microsoft.com/en-us/evalcenter/download-sql-server-2017-rtm',
    'https://www.microsoft.com/en-us/evalcenter/download-sql-server-2019',
    'https://www.microsoft.com/en-us/evalcenter/download-system-center-2019',
    'https://www.microsoft.com/en-us/evalcenter/download-system-center-2022',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-10-enterprise',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-11-enterprise',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-11-office-365-lab-kit',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2012-r2',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2012-r2-essentials',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2012-r2-essentials',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016-essentials',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019-essentials',
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022'
    'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025'
)


$found     = foreach( $href in $urls ) { TryFindDownloadUrl -Href $href }
$found_obj = foreach( $href in $urls ) { TryFindDownloadUrl -Href $href -PassThru }

$found | ft -auto

'Saved:
    $found      = matching download urls
    $found_obj  = the Html docs without filtering
' | Write-Host -fg 'orange'


<#
.NOTES
You can use a CSS Selector query to do most of the work in one step:

    $find = $resp.QuerySelectorAll('a[aria-label~="download"]')|ft

It simplifies the query, otherwise you'd have to do something like this:

    $find_manual =  $resp.QuerySelectorAll('a')
        | ?{ $_.Attributes['aria-label'].Value -match 'download' }


CSS Queries are cross-language, so the same query can be used by Javascript/Python/Etc

#>
