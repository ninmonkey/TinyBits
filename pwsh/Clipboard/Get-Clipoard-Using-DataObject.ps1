#requires -Modules ClassExplorer
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

<#
.LINK
    https://learn.microsoft.com/en-us/windows/win32/dataxchg/html-clipboard-format
.LINK
    https://github.com/dotnet/winforms/blob/62ebdb4b0d5cc7e163b8dc9331dc196e576bf162/src/System.Windows.Forms/src/System/Windows/Forms/OLE/DataObject.cs
.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.dataformats?view=windowsdesktop-9.0
.LINK
    https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.clipboard?view=windowsdesktop-9.0
.LINK
    https://learn.microsoft.com/en-us/windows/win32/dataxchg/clipboard-operations
.NOTES

HTML uses clipboard type 'CF_HTML'

See types:

    - [Windows.Forms.Clipboard]
    - [Windows.Forms.DataObject]
    - [Windows.Forms.TextDataFormat]
#>

<#
ctor's:

    DataObject();
    DataObject(object data);
    DataObject(string format, object data);
#>
# $Do = [Windows.Forms.DataObject]::new()

$Do = [DataObject]::new( [DataFormats]::Text, 'Text to store' )
# $do.GetText( [TextDataFormat]::Text ).

<#
Get methods:

    GetAudioStream
    GetData
    GetDataPresent
    GetFileDropList
    GetFormats
    GetImage
    GetText
#>

# Any Data present?
function Test-ClipboardDataPresent {
    <#
    .SYNOPSIS
        Query which formats are stored in the clipboard
    .link
        TinyBits\Test-ClipboardDataPresent
    .link
        TinyBits\Get-ClipboardDataFormat
    #>
    param(
        [DataObject] $DataObject,

        [switch] $FromClipboard,

        [Alias('AsString')]
        [switch] $NameOnly
    )

    $format_names = [DataFormats]
        | Find-Member -MemberType Field
        | % Name | Sort-Object -Unique

    if( -not $PSBoundParameters.ContainsKey('DataObject') -or $FromClipboard ) {
        $DataObject = [Clipboard]::GetDataObject()
    }

    if( $NameOnly ) { return $DataObject.GetFormats() }

    foreach( $name in $format_names ) {
        # if( $NameOnly ) {
        #     if( $DataObject.GetDataPresent( $name ) ) { $name }
        #     continue
        # }
        [pscustomObject]@{
            DataFormats    = $name
            GetDataPresent = $DataObject.GetDataPresent( $name )
        }
    }
}

function Get-ClipboardDataFormat {
    <#
    .SYNOPSIS
        Get data from clipboard, in many formats
    .notes
    original:
        Content = $DataObject.GetData( $found_types[1].DataFormats )
    .link
        TinyBits\Test-ClipboardDataPresent
    .link
        TinyBits\Get-ClipboardDataFormat
    .LINK
        https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.dataobject?view=windowsdesktop-9.0
    #>
    param(
        [Parameter(Position = 0)]
        [DataObject] $DataObject,

        [Parameter( ValueFromPipeline, ValueFromPipelineByPropertyName )]
        [Alias('Name', 'DataFormats')]
        [ArgumentCompletions(
            'Bitmap', 'CommaSeparatedValue', 'Dib', 'Dif', 'EnhancedMetafile', 'FileDrop', 'Html', 'Locale', 'MetafilePict', 'OemText', 'Palette', 'PenData', 'Riff', 'Rtf', 'Serializable', 'StringFormat', 'SymbolicLink', 'Text', 'Tiff', 'UnicodeText', 'WaveAudio'
        )]
        [string[]] $FormatName
        # [System.Windows.Forms.DataFormats[]] $FormatName
    )

    if( -not $PSBoundParameters.ContainsKey('DataObject') ) {
        $DataObject = [Clipboard]::GetDataObject()
    }

    foreach( $name in $FormatName ) {
        [pscustomobject]@{
            DataFormats = $name
            Content = $DataObject.GetData( $name )
        }
    }

}
write-warning 'wip almost '

return
if( $true ) {
    $inline_html = @'
<b>hi world<b>
<p>
<span style="color:red;"> red</span>
</p>
'@

    ConvertTo-CFHtml -Html $Html | Set-Clipboard -PassThru

    Test-ClipboardDataPresent -FromClipboard -AsString | Join-String -sep ', ' -op 'found: '

}


( $test_types = Test-ClipboardDataPresent -DataObject $Do )
$found_types = $test_types | Where-Object GetDataPresent
$found_types | Join-String -p DataFormats -f ' - {0}' -sep "`n" -op "Data Formats Present in Clipboard DataObject:`n"
# original
# $do.GetData( $found_types[1].DataFormats )

$query = Get-ClipboardDataFormat -DataObject $do -FormatName $found_types.DataFormats
$query.count




return

return
# Get-ClipboardDataFormat -DataObject $c_do -FormatName


$c_do = [Clipboard]::GetDataObject()
Get-ClipboardDataFormat -DataObject $c_do -FormatName ( [string[]] (
    Test-ClipboardDataPresent -DataObject $c_do | ? GetDataPresent | % DataFormats))
