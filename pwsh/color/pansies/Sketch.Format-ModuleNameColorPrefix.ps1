#requires -Module EZOut, Pansies 

# Import-Module EZOut
function _New-Gradients {
    param(
        [int] $Steps = 3,

        [ArgumentCompletions(
            'Lab',  'Lch',  'Hsl',  'Rgb',  'Xyz' )]
        [string] $ColorSpace = 'Lab'
    )
    if( $steps -lt 3) { $steps = 3 }
    $grads = [ordered]@{
        'GreenBlue'    = Get-Gradient -StartColor green blue -Width $Steps -ColorSpace $ColorSpace
        'TomatoOrchid' = Get-Gradient -StartColor tomato Orchid4 -Width $Steps -ColorSpace $ColorSpace
    }
    [PSCustomObject]$grads
}

function _Format-CommandToPrefix {
    param()
    process { 
        # $_.Name -split '-', 2 | Select -First 1
        @( $_.Name -split '-', 2 )[0]
    }
}
function _Format-ColorizeCommandPrefix {
    param( 
    )

    $all_commands = @( $Input ) 
    $prefix_list = $all_commands | _Format-CommandToPrefix | Sort-Object -Unique

    $cur_grads = ( _New-Gradients -Steps $prefix_list.Count -ColorSpace 'Lab' ).GreenBlue

    $i = 0;
    $color_map = @{}
    # foreach( $key in $prefix_list ) {
    #     $color_map[ $key ] = $cur_grads[ $i ] 
    #     $i++
    # }

    $i = 0;
    $color_map = @{}; 
    foreach( $i in 0..($prefix_list.Length -1) ) { 
        [string] $curKey =  $prefix_list[$i]
        $curKey | Write-Host -fg orange
        $color_map[ $curKey ] = $cur_grads[ $i ]
        #       $color_map[ $key ] = $cur_grads[ $i ] 
        #     $i++
    }
    $color_map


    $color_map.GetEnumerator() | ConvertTo-Json -depth 0 | ft -auto | out-string | Write-host -fg 'gray40' -bg 'gray10'

    wait-debugger
    $all_commands 
        | Join-String -f "`n{0}" -p {
            $_
        }
    # $prefix_list

    
} 
$cmd_list = gcm -m Pansies
# $prefix_list = @(
#     $cmd_list
#     | %{ $_.Name -split '-', 2 | Select -First 1 } | Sort-Object -Unique
# )

$prefix_list = @(
     $cmd_list | _Format-CommandToPrefix | Sort-Object -Unique )
     
     #  | %{ $_.Name -split '-', 2 | Select -First 1 } | Sort-Object -Unique
$cur_grads = _New-Gradients -Steps $prefix_list.count -ColorSpace 'Lab'
$cmd_list 
    | _Format-ColorizeCommandPrefix 

@'
example:
    $cur_grads = _New-Gradients -Steps 7 -ColorSpace 'Lab'
    
    $cmd_list | _Format-ColorizeCommandPrefix
    
    ( _New-Gradients -Steps 48).GreenBlue

'@ |Write-Host -fg 'magenta'