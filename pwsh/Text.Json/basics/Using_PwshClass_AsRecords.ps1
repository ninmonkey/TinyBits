#Requires -Version 7

<#
.SYNOPSIS
    This converts what is normally a [PSCO] into your type. This only works with basic field types
#>
class User {
    [DateTimeOffset] $Date = (Get-Date)
    [Int]            $Id   = (Get-Random -Minimum 0 -Maximum 1kb)
    [string]         $Name = 'anonymous'
}

$rows = @(  # Example array of data
    [User]::new()
    [User]::new()
)

# rows as [PSCO[]]
$as_psco = @( $rows | ConvertTo-Json | ConvertFrom-Json )

$as_psco[0]
    | Join-String -f ' is type: {0}' -p { $_.GetType().Name }


# rows as [User[]]
$as_user = [User[]] @( $rows | ConvertTo-Json | ConvertFrom-Json )
$as_user[0]
    | Join-String -f ' is type: {0}' -p { $_.GetType().Name }
