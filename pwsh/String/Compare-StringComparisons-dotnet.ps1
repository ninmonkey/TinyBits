
$pre = 'foo'
$end = "foo`0"
$pre.EndsWith( $end )

<#
.NOTES
TLDR: Depending on the version of dotnet it uses [StringComparer.CurrentCulture] vs [StringComparer.Ordinal]
    when using the [string] and [char] overloads without string comparers

See more

- https://github.com/dotnet/dotnet/blame/c22dcd0c7a78d095a94d20e59ec0271b9924c82c/src/runtime/src/libraries/System.Private.CoreLib/src/System/String.Comparison.cs#L600C13-L609C77
    - from: https://learn.microsoft.com/en-us/dotnet/api/system.string.endswith?view=net-10.0
- [Best practices for comparing strings in dotnet](https://learn.microsoft.com/en-us/dotnet/standard/base-types/best-practices-strings)


### StringComparer.CurrentCulture

    performs a case-sensitive string comparison using the word comparison rules of the current culture.
#>


$pre.EndsWith( "foo" )
    # True

$pre.EndsWith( "foo`0`0" )
    # True


"`0`0cat".IndexOfAny( "`0" )
    # 0

<# .... #>

'abc'.EndsWith("`u{0}`u{0}")
    # True

'abc'.EndsWith("`u{0}`u{0}f")
    # False

'abc'.EndsWith("`u{0}`u{0}")
    # True

'abc'.EndsWith("`u{0}`u{0}f")
    # False

'abc'.EndsWith("`u{0}`u{0}")
    # True

"`0" -eq "`0"
    # True
"`0" -eq ""
    # True

<# more ... #>

[CultureInfo]::InvariantCulture.CompareInfo.IsSuffix(
    'abc',"`0", ([System.Globalization.CompareOptions]::Ordinal) )
    # false

[CultureInfo]::InvariantCulture.CompareInfo.IsSuffix(
    'abc',"`0", ([System.Globalization.CompareOptions]::None) )
    # true

<# excessive tests #>
[System.StringComparer]::CurrentCulture.Compare( 'abc', "`u{0}`u{0}" )
    # 1

[System.StringComparer]::CurrentCulture.Compare( 'abc', "a`u{0}`u{0}" )
    # 1

[System.StringComparer]::CurrentCulture.Compare( '', "a`u{0}`u{0}" )
    # -1

[System.StringComparer]::CurrentCulture.Compare( 'abc', "a`u{0}`u{0}" )
    # 1

[System.StringComparer]::CurrentCulture.Compare( '', "a`u{0}`u{0}" )
    # -1

[System.StringComparer]::CurrentCulture.Compare( '', "not exist" )
    # -1

[System.StringComparer]::CurrentCulture.Compare( ' ', "not exist" )
    # -1

[System.StringComparer]::CurrentCulture.Compare( 'foo', "foo`u{0}" )
    # 0

[System.StringComparer]::CurrentCulture.Compare( 'foo', "foo`u{0}" )
    # 0

[System.StringComparer]::Ordinal.Compare( 'foo', "foo`u{0}" )
    # -1

[System.StringComparer]::CurrentCulture.Compare( 'foo', "foo`u{0}" )
    # 0

[System.StringComparer]::Ordinal.Compare( 'foo', "foo`u{0}" )
    # -1

[System.StringComparer]::CurrentCulture.Compare( 'foo', "`u{0}" )
    # 1

[System.StringComparer]::Ordinal.Compare( 'foo', "`u{0}" )
    # 102

$cmp_invar_   = [System.StringComparer]::InvariantCulture
$cmp_invar_IC = [System.StringComparer]::InvariantCultureIgnoreCase
$cmp_curr     = [System.StringComparer]::CurrentCulture
$cmp_curr_IC  = [System.StringComparer]::CurrentCultureIgnoreCase
$cmp_ord      = [System.StringComparer]::Ordinal
$cmp_ord_IC   = [System.StringComparer]::OrdinalIgnoreCase
