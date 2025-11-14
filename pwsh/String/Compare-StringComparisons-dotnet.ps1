#requires -Modules ClassExplorer
# Some parts may require 7, but easily convertible to 5

$pre = 'foo'
$end = "foo`0"
$pre.EndsWith( $end )

<#
.NOTES
### TLDR

Depending on the version of dotnet it uses [StringComparer.CurrentCulture] vs [StringComparer.Ordinal]
    when using the [string] and [char] overloads without string comparers

### See more

- [breaking changes in dotnet ~5](https://learn.microsoft.com/en-us/dotnet/standard/base-types/string-comparison-net-5-plus)
    - then [breaking change notification](https://learn.microsoft.com/en-us/dotnet/core/compatibility/globalization/5.0/icu-globalization-api)

> You can run code analysis rules CA1307: Specify StringComparison for clarity and CA1309: Use ordinal StringComparison to find these call sites in your code.

- https://github.com/dotnet/dotnet/blame/c22dcd0c7a78d095a94d20e59ec0271b9924c82c/src/runtime/src/libraries/System.Private.CoreLib/src/System/String.Comparison.cs#L600C13-L609C77
    - from: https://learn.microsoft.com/en-us/dotnet/api/system.string.endswith?view=net-10.0
- [Best practices for comparing strings in dotnet](https://learn.microsoft.com/en-us/dotnet/standard/base-types/best-practices-strings)
- [docs on Globalization ICU](https://learn.microsoft.com/en-us/dotnet/core/extensions/globalization-icu)

### dotnet code

#### Supplemental API Notes

- [CompareInfo](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-globalization-compareinfo)
- [CultureInfo](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-globalization-cultureinfo-currentculture)

#### Important classes

- [StringComparer.cs](https://github.com/dotnet/dotnet/blob/c22dcd0c7a78d095a94d20e59ec0271b9924c82c/src/runtime/src/libraries/System.Private.CoreLib/src/System/StringComparer.cs)
- [Globalization.CultureInfo](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo?view=net-10.0)
- enum [Globalization.CompareOptions](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.compareoptions?view=net-10.0)

#### Misc
- [Win32 API: CompareStringOrdinal](https://learn.microsoft.com/en-us/windows/win32/api/stringapiset/nf-stringapiset-comparestringordinal)
- [ICU versions and the Unicode versions that they implement, see Downloading ICU](https://icu.unicode.org/)
#>


$pre.EndsWith( "foo" )
    # True

$pre.EndsWith( "foo`0`0" )
    # True

<# If you want the shorthand overload, you can use a string #>

'abc'.EndsWith("`u{0}`u{0}", 'CurrentCulture' )
    # true
'abc'.EndsWith("`u{0}`u{0}", 'Ordinal' )
    # false


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

<# operators indirectly trigger it #>

"`0" -eq "`0"
    # True
"`0" -eq ""
    # True


'foo' -eq 'foo'
    # true

'foo' -eq "fo`u{0}o`u{0}"
    # true

<# static member types: #>
[System.StringComparer]::Ordinal.GetType().fullname
    # is a: [System.OrdinalCaseSensitiveComparer]
    # from: OrdinalCaseSensitiveComparer.Instance

[System.StringComparer]::CurrentCulture.GetType().fullname
    # is a: [System.CultureAwareComparer]
    # from: new CultureAwareComparer(CultureInfo.CurrentCulture, CompareOptions.None);

<# or using this overload #>
[System.StringComparer]::FromComparison( <# [StringComparison] #> 'ordinal')
[System.StringComparer]::FromComparison( <# [StringComparison] #> 'CurrentCulture')



<# more ... #>

[CultureInfo]::InvariantCulture.CompareInfo.IsSuffix(
    'abc',"`0", ([System.Globalization.CompareOptions]::None) )
    # true
[CultureInfo]::InvariantCulture.CompareInfo.IsSuffix(
    'abc',"`0", ([System.Globalization.CompareOptions]::Ordinal) )
    # false

[CultureInfo]::InvariantCulture.CompareInfo.IsSuffix(
    'abc',"`u{0}", ([System.Globalization.CompareOptions]::None) )
    # true
[CultureInfo]::InvariantCulture.CompareInfo.IsSuffix(
    'abc',"`u{0}", ([System.Globalization.CompareOptions]::Ordinal) )
    #false

# [cultureinfo]::InvariantCulture.CompareInfo.IsSuffix( 'ab', "`b`u{0}", 'Ordinal' )
# [cultureinfo]::InvariantCulture.CompareInfo.IsSuffix( 'ab', "`b`u{0}", 'None' )


[cultureinfo]::InvariantCulture.CompareInfo.IsSuffix( 'ab', "`b`u{0}", 'None' )
    # true
[cultureinfo]::InvariantCulture.CompareInfo.IsSuffix( 'ab', "`b`u{0}", 'None, IgnoreNonSpace' )
    # false
[cultureinfo]::InvariantCulture.CompareInfo.IsSuffix( 'ab', "`b`u{0}", 'Ordinal' )
    # false


[string]::Compare(
        "Administrator", "Adminiſtrator",
        <# [StringComparison] #> ([System.StringComparison]::CurrentCulture) )
    # out: -1

[string]::Compare(
        "Administrator", "Adminiſtrator",
        <# [StringComparison] #> ([System.StringComparison]::Ordinal) )
    # out: -268


<# Generic compare #>


$cmp_default = [System.Collections.Generic.Comparer[string]]::Default
$cmp_default.GetType() | Join-String -p { '<{0}<{1}><{2}]>>>' -f ( $_.Namespace, $_.Name, $_.GenericTypeArguments.name  ) }
    # out: <System.Collections.Generic<GenericComparer`1><String]>>>

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
