using namespace System.Windows.Forms
Add-Type -AssemblyName System.Windows.Forms

write-warning 'NYI: '
function Set-HtmlClipboard {
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

        $clip_header = @'
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
        $null = $sb.AppendLine( $clip_header )
    }
    process {
        $null = $sb.AppendLine( $Html )
    }
    end {
        write-warning 'nyi wip'





        return
        $null = $Sb.AppendLine( $html_suffix )
        $render_body = $Sb.ToString()
        if( $PassThru ) { $render_body }
        return

        # $render | Set-Clipboard -PassThru

        # $header_byteLen = [Text.Encoding]::UTF8.GetByteCount( $clip_header )
        # $full_byteLen   = [Text.Encoding]::UTF8.GetByteCount( $render_body )

        return
        # $final_contents = $

        [Windows.Forms.Clipboard]::SetText(
            <# string #> $render,
            <# TextDataFormat #> [Windows.Forms.TextDataFormat]::Html )

    }
}

$original_html = @'
<body>This is normal. <b>This is bold.</b> <i><b>This is bold italic.</b> This is italic.</i></body>
'@

$original_html | Set-HtmlClipboard -PassThru -Verbose
return


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

$Html3 = @'
<body>This is normal. <b>This is bold.</b> <i><b>This is bold italic.</b> This is italic.</i></body>
'@

$Expected = @'
Version:1.0
StartHTML:0121
EndHTML:0272
StartFragment:0006
EndFragment:0106
StartSelection:0180
EndSelection:0225
<html><!--StartFragment--><body>This is normal. <b>This is bold.</b> <i><b>This is bold italic.</b> This is italic.</i></body><!--EndFragment--></html>
'@
