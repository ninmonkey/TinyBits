function Fmt.H1 {
    process { 
        $some_colors = @( '#00688b', '#8b1a1a', '#4169e1' )
        $fg = Get-Random -Count 1 -InputObject $some_colors
        $fg = $some_colors[-1]
        $_ 
            | Join-String -f '## {0}' 
            | Write-Host -fg $fg
    }
}