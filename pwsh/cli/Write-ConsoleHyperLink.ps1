
filter Write-ConsoleHyperLink {
    <#
    .synopsis
        Show links using short names preserving a full absolute path to local files or web url
    .notes
        You can link to files: csv, json, hml
        Or web urls
    .example
        # example using a built-in pansies function:
        Pansies\New-HyperLink -Uri 'https://powerquery.how/list-transformmany' 'List.TransformMany()'
        New-HyperLink -Uri 'https://powerquery.how/list-transformmany' 'List.TransformMany()'
    .link
        https://github.com/PoshCode/Pansies/blob/45ff80a8f6b4ae52a4d7c36cbeb91ca93b8ed3d1/Docs/New-Hyperlink.md
    .link
        https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda#file-hyperlinks_in_terminal_emulators-md
    #>
    [Alias('TinyBits.WriteFilePathLink')]
    param()

    $item = Get-Item -ea 'ignore' $_
    if ( -not $Item ) { return $_ }
    $Label = '{0} {1:n2}kb' -f @(
       $Item.Name
       $Item.Length / 1kb
    )

    pansies\New-Hyperlink -Uri $Item.FullName -Object $Label
}

# opens windows control panel
New-HyperLink -uri 'ms-settings:sound' 'Sound Config'
# regular browser
New-HyperLink -Uri 'https://powerquery.how/list-transformmany' 'List.TransformMany()'

Get-ChildItem . -file | Select-Object -First 3 | Write-ConsoleHyperlink | Join-String -sep ', '


function Write-ConsoleWingetLogLinks {
    <#
    .synopsis
        Write Clickable links to any logs from today
    .example
        > Write-ConsoleWingetLogLinks

        # prints underlined filenames. Click with <Ctrl+LMB> to open the files.

        WinGet-2025-12-06-13-23-37.487.log 5.98kb, WinGet-2025-12-10-18-40-36.145.log 5.55kb, WinGet-2025-12-10-18-41-27.022.log 3.58kb
    #>
    param()

    $logRoot = Join-Path $Env:LocalAppData 'Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\DiagOutputDir' | Get-Item

    Get-ChildItem -path $LogRoot -file '*.log'  -Recurse
        | Where-Object { $_.LastWriteTime.Date -eq [datetime]::Now.Date }
        | Write-ConsoleHyperLink
}





# filter _WriteFilepathUri {
#     $item = Get-Item -ea 'ignore' $_
#     if ( -not $Item ) { return $_ }
#     $Label = '{0} {1:n2}kb' -f @(
#        $Item.Name
#        $Item.Length / 1kb
#     )

#     pansies\New-Hyperlink -Uri $Item.FullName -Object $Label
# }

# Get-ChildItem -path . -file | select-Object -First 3 | Write-ConsoleHyperLink
