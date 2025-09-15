#requires -Modules Pansies

# enable 24bit color
[PoshCode.Pansies.RgbColor]::ColorMode = 'Rgb24Bit'

function previewGrad {
    param( $gradient )

    $Glyph = ' '
    $all = @( $Input )
    $all
        | %{
            New-Text -bg $_ -Object $Glyph
        }
        | Join-String -sep ''
}

function PreviewAll {
    param(
        [RgbColor] $StartColor = 'red',
        [RgbColor] $EndColor = 'purple',
        [int] $Width = ([console]::WindowWidth - 6)
    )
    $colorSplat = @{
        StartColor = $StartColor
        EndColor = $EndColor
        Width = $Width
    }
    Get-Gradient @colorSplat -ColorSpace Hsl
    | previewGrad
    | Join-String -op 'Hsl: '

    Get-Gradient @colorSplat -ColorSpace Lab
    | previewGrad
    | Join-String -op 'Lab: '

    Get-Gradient @colorSplat -ColorSpace Lch
    | previewGrad
    | Join-String -op 'Lch: '

    Get-Gradient @colorSplat -ColorSpace Rgb
    | previewGrad
    | Join-String -op 'Rgb: '

    Get-Gradient @colorSplat -ColorSpace Xyz
    | previewGrad
    | Join-String -op 'Xyz: '
}
