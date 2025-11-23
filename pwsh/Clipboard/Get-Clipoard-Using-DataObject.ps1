#requires -Modules ClassExplorer
using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

<#
.LINK
https://github.com/dotnet/winforms/blob/62ebdb4b0d5cc7e163b8dc9331dc196e576bf162/src/System.Windows.Forms/src/System/Windows/Forms/OLE/DataObject.cs
.NOTES
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
    param(
        [DataObject] $DataObject
    )

    $format_names = [DataFormats]
        | Find-Member -MemberType Field
        | % Name | Sort-Object -Unique

    foreach( $name in $format_names ) {
        [pscustomObject]@{
            DataFormats    = $name
            GetDataPresent = $DataObject.GetDataPresent( $name )
        }
    }
}

( $test_types = Test-ClipboardDataPresent -DataObject $Do )
$found_types = $test_types | Where-Object GetDataPresent
$found_types | Join-String -p DataFormats -f ' - {0}' -sep "`n" -op "Data Formats Present in Clipboard DataObject:`n"
