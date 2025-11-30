
# helper functions to make the output easier to read
function ToByteCsv { $Input | Join-string -f '{0:x}' -sep ' ' -op '0x ' }
function H1 {
    param( $Message, $Foreground = 'darkyellow' )
    "`n${Message}" | Write-Host -fore $Foreground
}

$exampleText = 'Foo🐒Bar' # using an example that cannot be encoded as ascii

'$Example = "{0}"' -f $exampleText | Write-Host -fore darkyellow

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
