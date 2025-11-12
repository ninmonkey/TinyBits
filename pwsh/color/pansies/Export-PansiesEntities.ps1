#requires -PSEdition Core
#requires -Module Pansies
<#
.SYNOPSIS
    A few examples of encoding and decoding text as unicode. And collect and shape a list of codepoints from Pansies Emoji list
.LINK
    https://github.com/PoshCode/Pansies/blob/45ff80a8f6b4ae52a4d7c36cbeb91ca93b8ed3d1/Source/Assembly/Entities.Emoji.cs
#>

# You can lookup entities from the <SortedList<string, string>> Emoji = ...
# [PoshCode.Pansies.Entities]::Emoji['zombie']

# Escapes ansi escape color sequences, to make it human visible
filter ShowEscape { $_ -replace '\x1b', '`e' }
# Convert sequence to inline expressions for strings
filter EscapeAsExpression { $_ -replace '\x1b', '$([char]27)' }

function TextToCodepointsString {
    <#
    .SYNOPSIS
        TextToCodepointsString $fam
    .example
        > TextToCodepointsString '👨‍👩‍👦'
        > # out: U+1F468, U+200D, U+1F469, U+200D, U+1F466
    #>
    [OutputType('String')]
    param( [string] $Text )

    $Text.EnumerateRunes() | ForEach-Object {
        'U+{0:X4}' -f $_.Value
    } | Join-String -sep ', '
}

function Export-PansiesEntities {
    param()
    $emojis = foreach( $key in [PoshCode.Pansies.Entities]::Emoji.Keys  ) {
        $text = [PoshCode.Pansies.Entities]::Emoji[ $key ]
        [pscustomobject]@{
            PSTypeName     = 'Pansies.Entity.Summary'
            Name           = $key
            Text           = $text
            CodepointsList = TextToCodepointsString $text
        }
    }
    return $emojis
}

function DecodeAs {
    <#
    .SYNOPSIS
        Decodes string into bytes using specified encoding
    #>
    [CmdletBinding()]
    param(
        # Bytes to decode as some text
        [Parameter(Mandatory)]
        [byte[]] $Bytes,

        # EncodingInfo Name
        [ArgumentCompletions('utf-8', 'utf-16', 'utf-16le', 'ascii' )]
        $EncodingName = 'utf-8'
    )
    try { $enc = [Text.Encoding]::GetEncoding( $EncodingName ) }
    catch { throw }
    if( $bytes.count -eq 0 ) { throw "Bytes was null or empty!" }

    $Text = $enc.GetString( $Bytes )

    [pscustomobject]@{
        PSTypeName    = 'TextDecoding.Summary'
        EncodingName  = $Enc.WebName
        Text          = $Text
        Bytes         = $Bytes
        NumBytes      = $Bytes.Count
        TextLen       = $Text.Length
        TextRuneCount = @( $Text.EnumerateRunes() ).Count
    }
}
function EncodeAs {
    <#
    .SYNOPSIS
        Converts string into bytes using specified encoding
    #>
    param(
        # Text to encode
        [Parameter(Mandatory)]
        [string] $Text,

        # EncodingInfo Name
        [ArgumentCompletions('utf-8', 'utf-16', 'utf-16le', 'ascii' )]
        $EncodingName = 'utf-8'
    )

    # $Enc = [Text.Encoding]::GetEncoding( $EncodingName )
    # ensure exception on errors
    try { $enc = [Text.Encoding]::GetEncoding( $EncodingName ) }
    catch { throw }

    [byte[]] $Bytes = @( $Enc.GetBytes( $Text ) )

    [pscustomobject]@{
        PSTypeName    = 'TextEncoding.Summary'
        EncodingName  = $Enc.WebName
        Text          = $Text
        Bytes         = $Bytes
        NumBytes      = $Bytes.Count
        TextLen       = $Text.Length
        TextRuneCount = @( $Text.EnumerateRunes() ).Count
    }
}

function Convert-Text-ToInlineStringExpression {
    <#
    .EXAMPLE
        > Convert-PansiesEntity-ToInlineExpression -Text ([PoshCode.Pansies.Entities]::Emoji['zombie'])
            # optionally
            # | Join-String -Double | Set-Clipboard

        # output:
            "$( [char]::ConvertFromUtf32( 0x1f9df ) )"
    #>
    [Alias('Convert-PansiesEntity-ToInlineExpression')]
    param(
        [string] $Text
    )

$template = @'
$( [char]::ConvertFromUtf32( 0x{0} ) )
'@

    ( $Text.EnumerateRunes() ).Value.ForEach({
        $template -f $_.ToString('x')
    })
}
    # orig: -f ( [PoshCode.Pansies.Entities]::Emoji['zombie'].EnumerateRunes()  ).Value.ToString('x') | cl


$list = Export-PansiesEntities
'## found some' | Write-Host -fg 'tomato'

$list | ? name -match 'zz' | ft -auto
# if pwsh
<#
    "`u{01f18e}"
    ([Text.Rune] 0x001f18e).ToString()
#>

$src = "`u{01f18e}"
$out = EncodeAs -Text $src -EncodingName 'utf-8'

'show correct, and incorrect decodings' | Write-Host -fg 'tomato'
@(
    DecodeAs -Bytes $out.Bytes -EncodingName 'utf-8'
    DecodeAs -Bytes $out.Bytes -EncodingName 'utf-16'
    DecodeAs -Bytes $out.Bytes -EncodingName 'utf-16le'
    DecodeAs -Bytes $out.Bytes -EncodingName 'ascii'
) | Ft -auto

# $out = EncodeAs -Text $src -EncodingName 'utf-8'
# DecodeAs -Bytes $Out.Bytes -EncodingName 'utf-8'

'## convert entities from runes to inline expressions' | Write-Host -fg 'tomato'
[string] $inline_exp = @( foreach ( $cur in $tryStr ) {
    Convert-Text-ToInlineStringExpression -Text $cur
})  | Join-String -sep '' | Join-String -DoubleQuote

$inline_exp

@'
## try:

    $bytes.Bytes, $src, $out, $inline_exp, $list,
'@ | Write-host -fg 'salmon'
