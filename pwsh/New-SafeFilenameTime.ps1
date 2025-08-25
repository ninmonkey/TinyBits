function New-SafeTimeFilename {
    <#
    .SYNOPSIS
        Build a new filename using the current date and time, to the level of seconds
    .example
        > New-SafeTimeFilename
            # 2025-08-25_08-31-57Z

        > New-SafeTimeFilename -TemplateString 'screenshot-{0}.png'
            # screenshot-2025-08-25_08-31-57Z.png

        > New-SafeTimeFilename '{0}-main.log'
            # 2025-08-25_08-31-57Z-main.log

        > New-SafeTimeFilename 'AutoExport-{0}.xlsx'
            # AutoExport-2025-08-25_08-31-57Z.xlsx

    .link
        https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings#table-of-format-specifiers
    #>
    [OutputType('System.String')]
    [CmdletBinding()]
    param(
        # Set format string used by "-f" format
        [Parameter(Position = 0)]
        [ArgumentCompletions(
            "'{0}'",
            "'AutoExport-{0}.xlsx'",
            "'main-{0}.log'",
            "'{0}-main.log'",
            "'screenshot-{0}.png'"
        )]
        [string]$TemplateString = '{0}'
    )
    $render = $TemplateString -f @(
        (Get-Date).ToString('u') -replace '\s+', '_' -replace ':', '-' )

    "Generated: '${render}'" | Write-Verbose
    $render
}
