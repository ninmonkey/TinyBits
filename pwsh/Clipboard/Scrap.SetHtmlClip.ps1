using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

function _Set-HtmlClipboard {
    <#
    .SYNOPSIS
    #>
    param(
        [parameter(ValueFromPipeline, Mandatory)]
        [string] $Html,

        [switch] $PassThru
    )
    begin {
        [Text.StringBuilder] $sb = ''

        $html_prefix = @'
Version:0.9
StartHTML:-1
EndHTML:-1
StartFragment:{0:D9}
EndFragment:{1:D9}
<html><body>
'@
        $html_suffix = @'
</body></html>
'@
        $null = $sb.AppendLine( $html_prefix )
    }
    process {
        $null = $sb.AppendLine( $Html )
    }
    end {
        $Sb.AppendLine( $html_suffix )
        $render_body = $Sb.ToString()
        # $render | Set-Clipboard -PassThru

        $header_byteLen = [Text.Encoding]::UTF8.GetByteCount( $html_prefix )
        $full_byteLen   = [Text.Encoding]::UTF8.GetByteCount( $render_body )

        write-warning 'nyi wip'
        return
        # $final_contents = $

        [Windows.Forms.Clipboard]::SetText(
            <# string #> $render,
            <# TextDataFormat #> [Windows.Forms.TextDataFormat]::Html )

        if( $PassThru ) { $render }
    }
}

filter ByteCount8 { [Text.Encoding]::UTF8.GetByteCount( $_ ) }

'<html>' |  ByteCount8


$html1 = @'
<body>This is normal. <b>This is bold.</b> <i><b>This is bold italic.</b> This is italic.</i></body>
'@

$Expected1 = @'
Version:1.0
StartHTML:0121
EndHTML:0272
StartFragment:0006
EndFragment:0106
StartSelection:0180
EndSelection:0225
<html><!--StartFragment--><body>This is normal. <b>This is bold.</b> <i><b>This is bold italic.</b> This is italic.</i></body><!--EndFragment--></html>
'@


& {
    $metadata_head = @'
Version:1.0
StartHTML:0121
EndHTML:0272
StartFragment:0006
EndFragment:0106
StartSelection:0180
EndSelection:0225
'@

    $metadata_head | ByteCount8

    [Text.Encoding]::UTF8.GetByteCount( $metadata_head )

    $docStart = @'
<html>
'@

    $docStart | ByteCount8



}


return
# Version:1.0
# StartHTML:0121
# EndHTML:0272
# StartFragment:0006
# EndFragment:0106
# StartSelection:0180
# EndSelection:0225


$Html = @'
<b>hi world<b>
<p>
<span style="color:red;"> red</span>
</p>

'@

$Html | Set-HtmlClipboard -PassThru


$Html2 = @'
<body><table border><tr><th rowspan=2>head1</th><td>item 1</td><td>item 2</td><td>item 3</td><td>item 4</td></tr><tr><td>item 5</td><td>item 6</td><td>item 7</td><td>item 8</td></tr><tr><th>head2</th><td>item 9</td><td>item 10</td><td>item 11</td><td>item 12</td></tr></table></body>
'@
