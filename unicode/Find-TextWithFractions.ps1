
$codepoints = 0x0..0xffff
$query = $codepoints.ForEach({
    $num = $_
    try {
        $str = [char]::ConvertFromUtf32( $num )
    } catch {
        return
    }

    [pscustomobject]@{
        Codepoint = $num
        Hex       = '0x' + $num.ToString('x4')
        NumericValue = [Globalization.CharUnicodeInfo]::GetNumericValue( $str, 0 )
        Str       = $str
    }

})
'Search all values for: NumericValue != -1' | Write-Host -fore Orange
$query | Where-Object NumericValue -NE -1 | Format-Table

function strToInfo {
    param(
        [Alias('InputObject')]
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Text
    )
    process {
        $num = [char]::ConvertToUtf32( $Text, 0 )
        [pscustomobject]@{
            Codepoint    = $num
            Hex          = '0x' + $num.ToString('x4')
            NumericValue = [Globalization.CharUnicodeInfo]::GetNumericValue( $Text, 0 )
            Str          = $Text
        }
    }
}

'Inspect specific strings' | Write-Host -fore Orange
$examples = '3', '7', '²', '³', '¹', '¼', '½', '¾', '෪', '༰', '౦', '⅐', '⅑', '⅒', '⅓', '⅔', '⅕', '⅖', '⅗', '⅘', '⅙', '⅚', '⅛', '⅜', '⅝', '⅞', '⅟', 'Ⅰ', 'Ⅱ', '₀', '₂', '₅', 'Ⅲ', 'Ⅳ', 'Ⅴ', 'Ⅵ', 'Ⅶ', 'Ⅷ', 'Ⅸ', 'Ⅹ', 'Ⅺ', 'Ⅻ', 'Ⅼ', 'Ⅽ', 'Ⅾ', 'Ⅿ', 'ⅰ', 'ⅱ', 'ⅲ', 'ⅳ', 'ⅴ', 'ⅵ', 'ⅶ', 'ⅷ', 'ⅸ', 'ⅹ', 'ⅺ', 'ⅻ', 'ⅼ', 'ⅽ', 'ⅾ', 'ⅿ', 'ↀ', 'ↁ', 'ↂ', 'ↅ', '↉', '⒑', '⒔', '⑺', '⑾', '⒂', '⒍', '⑦', '⑲', '⓭', '⓪', '⓸', '❺', '➅', '➐', '〡', '〤', '〨', '〺', '㉑', '㉔', '㉘', '㉊', '㈥', '㈢', '㊀', '㊉', '㊶', '꠲', '３', '７'
$examples | strToInfo | Ft -auto

<#
output:

     9450 0x24ea         0.00 ⓪
     9464 0x24f8         4.00 ⓸
    10106 0x277a         5.00 ❺
    10117 0x2785         6.00 ➅
    10128 0x2790         7.00 ➐
    12321 0x3021         1.00 〡
    12324 0x3024         4.00 〤
    12328 0x3028         8.00 〨
    12346 0x303a        30.00 〺
    12881 0x3251        21.00 ㉑
    12884 0x3254        24.00 ㉔
    12888 0x3258        28.00 ㉘
    12874 0x324a        30.00 ㉊
    12837 0x3225         6.00 ㈥
    12834 0x3222         3.00 ㈢
    12928 0x3280         1.00 ㊀
    12937 0x3289        10.00 ㊉
    12982 0x32b6        41.00 ㊶
    43058 0xa832         0.75 ꠲
    65299 0xff13         3.00 ３
#>
