function TinyBits.GotoLocation {
    <#
    .synopsis
        go to a path, auto convert-paths, since push/pop doesn't
    .Description
        You can't simply to split and push, like this because of the parameter binding

            $log | Split-Path | Push-Location

        It requires a convert-path or ToString like this:

            $log | Split-Path | Convert-Path | Push-Location

        ## Note:

        You *can*, but, your location and prompt becomes
            "Microsoft.PowerShell.Core\FileSystem::C:\foo\bar"

        Instead of

            "C:\foo\bar"
    #>
    [CmdletBinding()]
    [OutputType( [System.IO.FileSystemInfo] )]
    [Alias('Goto')]
    param(
        [Parameter(ValueFromPipeline, Mandatory)]
        [Object] $InputObject,


        # output paths found, else, run in vs code.
        [Alias('WithoutAutoOpen')]
        [switch] $PassThru
    )
    begin {}
    process {
        $Path = Get-Item -ea ignore $InputObject
        if( $Path -is [IO.DirectoryInfo] ) {
            $Path | ConvertPath | Push-Location
            return $Path
        }
        if( $Path -is [IO.FileSystemInfo] ) {
            $Path.Directory | ConvertPath | Push-Location
            return $Path.Directory
        }
        'Unhandled input type when converting to path: {0}' -f $InputObject.GetType().Name | Write-Warning
    }
}
