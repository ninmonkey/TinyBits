#requires -PSEdition Core
#requires -Module Pansies
<#
.SYNOPSIS
    Collect and shape a list of codepoints from Pansies Emoji list
.LINK
    https://github.com/PoshCode/Pansies/blob/45ff80a8f6b4ae52a4d7c36cbeb91ca93b8ed3d1/Source/Assembly/Entities.Emoji.cs
#>

# You can lookup entities from the <SortedList<string, string>> Emoji = ...
# [PoshCode.Pansies.Entities]::Emoji['zombie']

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
            Name = $key;
            Text = $text
            CodepointsList = TextToCodepointsString $text
        }
    }
    return $emojis
}

function EncodeAsOther {
    param(
        [string] $Text,
        $EncodingName = 'utf-8'
    )

    $Enc = [Text.Encoding]::GetEncoding( $EncodingName )

    # ensure exception on errors
    try {
        [Text.Encoding]::GetEncoding( $EncodingName )
    } catch { throw }

    [byte[]] $Bytes = @( $Enc.GetBytes( $Text ) )

    [pscustomobject]@{
        InputText = $Text
        Encoding  = $Enc.WebName
        Bytes = $Bytes
    }

    # if( $Enc.WebName -eq 'windows-1252' ) { throw "Failed to GetEncoding('$EncodingName') ! Windows-1252 was returned instead!" }
}


$list = Export-PansiesEntities

$list | ? name -match 'zz'

# if pwsh
"`u{01f18e}"
([Text.Rune] 0x001f18e).ToString()
