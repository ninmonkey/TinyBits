#requires -Version 7
#requires -Modules Pansies


function TinyBits.Get-WingetFavPackage {
    <#
    .SYNOPSIS
        List some specific winget packages, but let the user decide what to install
    .NOTES
        # $future: dynamic cached lookup of urls, or can I read manifest directly from local ?
        ($out = winget show --disable-interactivity --id sharkdp.hexyl)
        $out |rg -i 'http|$'
    .LINK
    .LINK
        TinyBits.Get-WingetPackageInfo
    .LINK
        TinyBits.Get-WingetFavPackage
        https://learn.microsoft.com/en-us/windows/package-manager/winget/
    .LINK
        https://learn.microsoft.com/en-us/windows/package-manager/winget/list
    .LINK
        https://learn.microsoft.com/en-us/windows/package-manager/winget/mcp-server
    #>
    param()
    $packages = @(
        [PSCustomObject]@{
            Id         = 'Rustlang.Rustup'
            Name       = 'Rust toolchain'
            Desc       = 'rustup'
            ProjectUrl = ''
        }
        [PSCustomObject]@{
            Id         = 'sharkdp.bat'
            Name       = 'bat'
            Desc       = 'Console pager with syntax highlighting'
            ProjectUrl = ''
        }
        [PSCustomObject]@{
            Id         = 'sharkdp.fd'
            Name       = 'fd find'
            Desc       = 'like `find` but with a cleaner UX. Works great mixing with pwsh.'
            ProjectUrl = ''
        }
        [PSCustomObject]@{
            Id         = 'sharkdp.hexyl'
            Name       = 'hexyl'
            Desc       = 'like `find` but with a cleaner UX. Works great mixing with pwsh.'
            ProjectUrl = ''
        }
    )
    return $packages
}


function TinyBits.Get-WingetPackageInfo {
    <#
    .synopsis
        Super naive implementation. Should really use a manifest or cached value. Just a quick fix.
    .example
        TinyBits.Get-WingetFavPackage | Select -First 1 | TinyBits.Get-WingetPackageInfo
    .LINK
        https://learn.microsoft.com/en-us/windows/package-manager/winget/show
    .LINK
        TinyBits.Get-WingetPackageInfo
    .LINK
        TinyBits.Get-WingetFavPackage
    #>
    param(
        [Alias('Id')]
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]] $PackageId,

        [ArgumentCompletions('winget', 'msstore')]
        [string] $PackageSource,

        # Emit raw stdout from command ?
        [Alias('RawStdout')]
        [switch] $passThru
    )
    begin {
        $binWinget = Get-Command -Name 'winget' -CommandType Application -TotalCount 1 -ea 'stop'
        write-warning 'Note: this command is not using cached results, so it''s slow'

    }
    process {
        foreach($curId in $PackageId) {
            $binArgs = @('show', '--disable-interactivity', '--id', $curId, '--source', $PackageSource)
            $binArgs | Join-String -sep ' ' -op '    invoke bin => winget ' | Write-Host -fg Orchid4

            $out = & $binWinget @binArgs
            if( $PassThru ) { $out ; continue; }

            'then'
            $out.forEach({
                $line = $_
                $key, $value = $line -split '\:\s+', 2
                # if( $key -notmatch '^\w' ) { continue }
                if( $line -notmatch 'homepage|url' ) { continue; }
                $key   = ($key)?.Trim()
                $value = ($value)?.Trim()

                if( $key -match 'url|homepage' ) {
                    # $key, $value -join ' = '
                    [PSCustomObject]@{
                        PSTypeName = 'TinyBits.WingetCommand.Show.Url.Record'
                        WingetId = $curId
                        Key = $Key
                        Url = $Value
                        # RawOutput = $out
                    }
                }
            })



            write-warning 'Sketch, wip... '
            ','
            # filter only [1] "key: value" pairs, and [2] url/homepage links
            @($out.ForEach({
                # $key, $value = $_ -split ':\s*', 2
                # $key   = ($key)?.trim()
                # $value = ($value)?.trim()

                # if( $key -notmatch 'url|homepage' ) { continue; }


                [PSCustomObject]@{
                    PSTypeName = 'TinyBits.WingetCommand.Show.Url.Record'
                    WingetId = $curId
                    Key = $Key
                    Url = $Value

                    # RawOutput = $out
                }
                # [pscustomobject]@{ k = $K.Trim() ; v = $v; }
            }))
            # | ? { $_.k -match 'url|homepage' }
            # | fl



        }
    }
}


#$error.clear(); . $dotSRc;
$error.clear();

($fav = TinyBits.Get-WingetFavPackage )
$fav | Select -First 1 | TinyBits.Get-WingetPackageInfo #-passThru
