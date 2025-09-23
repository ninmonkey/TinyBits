<#
.Description
   - Lets you pipe a list of values to 'fzf'.
   - It creates a unique ID that is not visible in 'fzf -m'
   - You get both the selected values back, and their unique Ids (since objects don't pass)
   - Or use a property name, like a proceses's PID for a distinct value

   Example at the bottom
#>

function Format-PrefixNumberList {
    <#
    .synopsis
        Prefixes each line with an incrementing ID
    #>
    [Alias('Fmt.NL')]
    param() 
    $i = 0
    $lines = @( $Input )
    $lines.ForEach({ '{0}: {1}' -f ( ($i++), $_ ) })
} 

function Format-PrefixByProperty {
    <#
    .synopsis
        Use another Int like a process's PID
    .example
        get-process 
            | Format-PrefixByProperty -PropertyIdName Id -DisplayPropertyName Name
    .example
        Get-Process | 
            Format-PrefixByProperty Id CommandLine
        
            Get-Process | 
            Format-PrefixByProperty Id
    #>
    param(
        [Parameter( Mandatory, ValueFromPipeline )]
        $InputObject, 

        # When missing, writes property name errors and continues onto next 
        # Future: When not specified: Use auto incrementing Integer by default
        [Parameter( Mandatory, Position = 0 )]
        [string] $PropertyIdName, 

        # When missing, falls back to 'ToString()' and a warning
        [Parameter( Position = 1 )]
        [string] $DisplayPropertyName = 'Name'
    )
    process {
        if( [string]::IsnullOrWhiteSpace( $PropertyIdName ) ) {
            Write-Error "PropertyIdName '${PropertyIdName}' was blank!"
            return
        }
        if( [string]::IsnullOrWhiteSpace( $DisplayPropertyName ) ) {
            Write-Verbose "PropertyDisplayName '${DisplayPropertyName}' was blank!"
        }

        [string] $MaybeName = $InputObject.$DisplayPropertyName
        '{0}: {1}' -f @( 
            $InputObject.$PropertyIdName
            
            $maybeName.Length -gt 0 ? 
                    $InputObject.$DisplayPropertyName : 
                    ($InputObject)?.ToString() 
        )
    }
}

function ConvertToIdObjectPair { 
    # future: 'Id', 'Name' columns should use name of properties used
    process {
    $id, $name = $_ -split ': ', 2
    [PSCustomObject]@{
        Id   = [int] $id
        Name = $name.Trim()
    }
} }

# response gives the selection ID and value
'Example: $SelectedNames = select from a list of strings' | Write-Host -foregroundColor Blue
$names = 'bob', 'jen', 'Alice', 'BOB', 'jen '
$SelectedNames = @( 
    $names  
        | Fmt.NL # | Sort-Object
        | fzf -m --with-nth=2 --delimiter=': '
)
$SelectedNames | Join-String -sep ', ' 

'Example: $SelectedProcesses = select from a processe list' | Write-Host -foregroundColor Blue

$SelectedProcesses = 
    Get-Process | Sort-Object Name
        | Format-PrefixByProperty -PropertyIdName Id
        | fzf -m --with-nth=2 --delimiter=': '
        | ConvertToIdObjectPair

$SelectedProcesses | Join-String Id -sep ', ' -op 'Selected Process IDs: = '

Get-variable 'SelectedNames', 'SelectedProcesses' | ft -AutoSize



