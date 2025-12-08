#requires -Module EZOut, Pansies 

# Import-Module EZOut

function _Format-ColorizeCommandPrefix {
    param( 
    )

    $all_commands = @( $Input ) 
    $prefix_list = 
        $all_commands.forEach({
            $_.Name -split '-', 2 | Select -First 1
        }) | Sort-Object -Unique

    $prefix_list
} 
$cmd_list = gcm -m Pansies
# $prefix_list = @(
#     $cmd_list
#     | %{ $_.Name -split '-', 2 | Select -First 1 } | Sort-Object -Unique
# )
function _New-Gradients {
    param(
        [int] $Steps = 3,
        [ArgumentCompletions(
            'Lab',  'Lch',  'Hsl',  'Rgb',  'Xyz'
        )]
        [string] $ColorSpace = 'Lab'
    )
    $grads = [ordered]@{
        'GreenBlue'    = Get-Gradient -StartColor green blue -Width $Steps -ColorSpace $ColorSpace
        'TomatoOrchid' = Get-Gradient -StartColor tomato Orchid4 -Width $Steps -ColorSpace $ColorSpace
    }
    [PSCustomObject]$grads
}

$cur_grads = _New-Gradients -Steps 7 -ColorSpace 'Lab'
$cmd_list 
    | _Format-ColorizeCommandPrefix 

@'
example:
    $cur_grads = _New-Gradients -Steps 7 -ColorSpace 'Lab'
    
    $cmd_list | _Format-ColorizeCommandPrefix
    
    ( _New-Gradients -Steps 48).GreenBlue

'@ |Write-Host -fg 'magenta'