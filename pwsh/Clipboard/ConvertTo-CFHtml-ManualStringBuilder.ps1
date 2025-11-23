function ConvertTo-CFHtml {
    <#
  .SYNOPSIS
    Converts HTML to CF_HTML, the format expected by Windows Clipboard. Workaround for the removal of the -asHtml from Set-Clipboard parameter in PWSH 7
    .link
    original: SaladProblems <https://discord.com/channels/180528040881815552/447476117629304853/1441874764229640292>
  #>
    param(
        [parameter(ValueFromPipeline, Mandatory)]
        [string]$Html
    )
    begin {
        $sb = [System.Text.StringBuilder]::new()
        $cfhtmlTemplate = @'
Version:0.9
StartHTML:0000000105
EndHTML:{0:D10}
StartFragment:0000000182
EndFragment:{1:D10}
<html>
<head>
<meta charset="utf-8">
</head>
<body>
<!--StartFragment-->
{2}
<!--EndFragment-->
</body>
</html>
'@

    }
    process {
        $null = $sb.AppendLine( $Html )
    }
    end {
        $combinedHtml = $sb.ToString()
        $cfhtmlTemplate -f ($combinedHtml.Length + '<!--EndFragment-->'.Length), ($combinedHtml.Length + 93), $combinedHtml

    }
}

$Html = @'
<b>hi world<b>
<p>
<span style="color:red;"> red</span>
</p>

'@

$rend = ConvertTo-CFHtml -Html $Html
$rend | Set-Clipboard -PassThru
