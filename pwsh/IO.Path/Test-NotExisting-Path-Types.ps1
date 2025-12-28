#requires -PSEdition Core
<#
.synopsis
    Compare testing paths types that don't currently exist with:
        Test-Path $Path -PathType <Leaf | Container>
.notes

## output ##

    IsLeaf IsContainer TestPath TypeOf        IsNull IsBlank IsEmptyStr Obj
    ------ ----------- -------- ------        ------ ------- ---------- ---
    <null> <null>      <null>   ␀               True    True       True
    False  True        True     DirectoryInfo  False   False      False c:\logs
    False  False       False    DirectoryInfo  False   False      False c:\logs\2
    False  True        True     DirectoryInfo  False   False      False H:\data\2025\pwsh
    False  False       False    FileInfo       False   False      False c:\data.log
    False  False       False    FileInfo       False   False      False c:\foo\file.ps1
    True   False       True     FileInfo       False   False      False C:\..\Microsoft.PowerShell_profile.ps1
    False  False       False    String         False    True       True
    False  False       False    String         False    True      False
    False  False       False    String         False   False      False _
    True   False       True     String         False   False      False C:\..\Microsoft.PowerShell_profile.ps1

## Summary ##

- 'IsLeaf' was *always* false, except if the following was true:
    - The filepath itself exists
    - Type could be < [String] | [FileInfo] >

- 'IsLeaf' was false even when it was an instance of [FileInfo]
    - when the file wasn't created yet

#>

$col_file = 'c:\data.log', 'c:\foo\file.ps1' -as [IO.FileInfo[]]
$col_dir  = 'c:\logs', 'c:\logs\2'           -as [IO.DirectoryInfo[]]
$example = @(
    $col_file
    $col_dir
    $Null, '', '_', '  '
    $PROFILE
    Get-Item $Profile
    Get-Item '.'
)

$summary = $example | ForEach-Object {
    [pscustomobject]@{
        IsLeaf      = ( Test-Path -ea ignore $_ -PathType Leaf ) ?? '<null>'
        IsContainer = ( Test-Path -ea ignore $_ -PathType Container ) ?? '<null>'
        TestPath    = ( Test-Path -ea Ignore $_ ) ?? '<null>'

        TypeOf      = ( $_ )?.GetType().Name ?? '␀'

        IsNull      = $null -eq $_
        IsBlank     = [String]::IsNullOrWhiteSpace( $_ )
        IsEmptyStr  = [String]::IsNullOrEmpty( $_ )

        Obj         = $_
    }
} | Sort-Object TypeOf, Obj

$summary | Format-Table -AutoSize
