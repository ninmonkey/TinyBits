$Root = Get-Item $PSScriptRoot
$Config = @{
    InputImage = Join-Path $root './SetManyPixels-grad8rgb.bmp' | Get-Item -ea 'stop'
    Export = Join-Path $root 'export.bmp'
}

$bmp  = [Drawing.Bitmap]::FromFile( $Config.InputImage )
$rect = [Drawing.Rectangle]::new(0, 0, $bmp.Width, $bmp.Height)

[Drawing.Imaging.BitmapData] $bdata = $bmp.LockBits( $rect,
    [Drawing.Imaging.ImageLockMode]::ReadWrite,
    [Drawing.Imaging.PixelFormat]::Format24bppRgb )

[IntPtr] $ptr = $bdata.Scan0

[Int] $numBytes     = [Math]::Abs( $bdata.Stride ) * $bmp.Height
[byte[]] $rgbValues = New-Object byte[] ( $numBytes )

[System.Runtime.InteropServices.Marshal]::Copy( $ptr, $rgbValues, 0, $numBytes )

for( $i = 2; $i -lt $rgbValues.Length; $i += 3 ) {
    # Sets everything to red
    $rgbValues[$i] = 255
    $rgbValues[$i - 1] = 0
    $rgbValues[$i - 2] = 0
}

[System.Runtime.InteropServices.Marshal]::Copy(
    $rgbValues,
    0,
    $ptr,
    $numBytes
)

$bmp.UnlockBits( $bdata )
$bmp.Save( $Config.Export, [Drawing.Imaging.ImageFormat]::Bmp)
"Saved to: $( $Config.Export )" | Write-Host
