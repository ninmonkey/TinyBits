
function JoinStr {
    <#
    .SYNOPSIS
        Tiny Sugar for WinPS 5, without being a full polyfill of Join-String
    .NOTES
        For a full polyfill, check out: https://github.com/FriedrichWeinmann/string
    .LINK
        https://github.com/FriedrichWeinmann/string
    .example
        $Profile | gm -MemberType Properties |
            JoinStr Name -pre '$x | gm => ' -Separator "`n - "
    .example
        [System.Text.EncodingInfo] | Fime | JoinStr -PropertyName MemberType -Unique
    .example
        [System.Text.EncodingInfo].DeclaredMembers | JoinStr MemberType -Unique
            # out: Constructor, Field, Method, Property
    .example
        [System.Text.EncodingInfo].DeclaredProperties | JoinStr Name -sep "`n"
            # out: CodePage␊DisplayName␊Name␊
    #>
    param(
        [Parameter(ValueFromPipeline, Mandatory )]
        [object[]] $InputObject,

        [Parameter(Position = 0 )]
        [string] $PropertyName = 'Name',

        [Parameter(Position = 1 )]
        [string] $Separator = ', ',

        # otherwise sort is default
        [switch] $WithoutSort,

        # Implicitly includes sorting. # sort and distinct
        [Alias('Distinct')]
        [switch] $Unique
    )
    begin {
        [System.Collections.Generic.List[Object]] $items = @()
    }
    process {
        foreach($obj in $InputObject ) { $items.Add( $Obj ) }
    }
    end {
        $names = ($Items).$PropertyName
        if( $Unique ) {
            $names = $names | Sort-Object -Unique
        } elseif ( -not $Unique -and -not $WithoutSort ) {
            $names = $names | Sort-Object
        } else {
            # nothing
        }
        @( $names ) -join $Separator
    }
}
