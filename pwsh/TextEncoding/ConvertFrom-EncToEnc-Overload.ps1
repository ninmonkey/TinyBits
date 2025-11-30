#requires -PSEdition Core
#requires -modules ClassExplorer

<#
.synopsis
    Encoding and decoding text

.Notes
See more / Related Types:

 - [System.Text.Encoder]
 - [System.Text.EncoderFallbackException]
#>

# helper functions to make the output easier to read
function ToByteCsv { $Input | Join-string -f '{0:x}' -sep ' ' -op '0x ' }
function H1 {
    param( $Message, $Foreground = 'darkyellow' )
    "`n${Message}" | Write-Host -fore $Foreground
}

$exampleText = 'Foo🐒Bar' # using an example that cannot be encoded as ascii

H1 'Related types' -fore red
find-type -Namespace 'System.Text*'
   | ? Name -Match 'Encoding|encoder|decoding|decoder'
   | sort namespace, name | Ft -GroupBy namespace


h1 "Example = '${exampleText}'"

H1 '[1] $Example => Encode Utf8'
[Text.Encoding]::UTF8.GetBytes( $exampleText ) | ToByteCsv

H1 '[1] $Example => Encode Ascii'
[Text.Encoding]::Ascii.GetBytes( $exampleText ) | ToByteCsv

H1 '[2] $Example => Encode Utf8 => Decode utf8'
$bytes = [Text.Encoding]::UTF8.GetBytes( $exampleText )
[Text.Encoding]::UTF8.GetString( $bytes )

H1 '[2] $Example => Encode Ascii => Decode Ascii'
$bytes = [Text.Encoding]::Ascii.GetBytes( $exampleText )
[Text.Encoding]::Ascii.GetString( $bytes )
    # causes bad output: 'Foo??Bar'

H1 '[2] $Example => Encode Utf8 => Decode Ascii'
$bytes = [Text.Encoding]::Utf8.GetBytes( $exampleText )
[Text.Encoding]::Ascii.GetString( $bytes )
    # causes bad output: 'Foo????Bar'


$enc1250 = [Text.Encoding]::GetEncoding(1250)
$enc1251 = [Text.Encoding]::GetEncoding(1251)
$enc8    = [Text.Encoding]::UTF8
$enc16   = [Text.Encoding]::Unicode                      # is: utf-16 LE
$enc16BE = [Text.Encoding]::BigEndianUnicode             # is: utf-16 BE
$encCyr  = [Text.Encoding]::GetEncoding('windows-1251')

h1 '[3] GetEncoding() for 1250, 1251'
$enc1250.GetBytes( $exampleText ) | ToByteCsv
$enc1251.GetBytes( $exampleText ) | ToByteCsv

h1 '[3] $Example => Encode: UTF8 => Decode: 1250'
$enc1250.GetString( $enc8.GetBytes( $ExampleText ) )

h1 '[3] $Example => Encode: UTF8 => Decode: 1250'
$enc1251.GetString( $enc8.GetBytes( $ExampleText ) )

h1 '[3] $Example => Encode: UTF-16 => Decode: UTF8'
$enc8.GetString( $enc16.GetBytes( $exampleText ) )
# out: Foo=��Bar

h1 '[3] $Example => Encode: UTF-16 BE => Decode: UTF8'
$enc8.GetString( $enc16Be.GetBytes( $exampleText ) )
# out: Foo�=�Bar

h1 '[3] $Example => Encode: UTF-16 BE => Decode: Cyrillic (Win)'
$encCyr.GetString( $enc16.GetBytes( $exampleText ))

h1 '[3] $Example => Encode: UTF-8 => Decode: Cyrillic (Win)'
$encCyr.GetString( $enc8.GetBytes( $exampleText ))

# ... more
$enc_oem437      = [Text.Encoding]::GetEncoding( 437 )  # aka: 'IBM437'
$enc_oemCyrillic = [Text.Encoding]::GetEncoding( 855 )  # aka: 'IBM855'

h1 '[3] $Example => Encode: UTF-8 => Decode: "OEM United States"'
$enc_oem437.GetString( $enc8.GetBytes( $exampleText ))

h1 '[3] $Example => Encode: UTF-8 => Decode: "OEM Cyrillic"'
$enc_oemCyrillic.GetString( $enc8.GetBytes( $exampleText ))

h1 '[4] using [Text.Encoding]::Convert( <enc1>, <enc2>, <bytes> )'

$orig_bytes = $enc8.GetBytes( $exampleText )
$new_bytes  = [Text.Encoding]::Convert( $enc8, $enc16, $orig_bytes )
$enc16.GetString( $new_bytes )

h1 '[3] Search encodings by name: -match "cy" or "oem"'
[Text.Encoding]::GetEncodings()
    | ? DisplayName  -Match 'cy|oem'
