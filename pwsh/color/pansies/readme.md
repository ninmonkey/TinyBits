[Go Back ⮥](./..) or [⮥ ⮥](./../../readme.md)

Console colors using the `pansies` module

- [Compare-Gradient-Colorspaces.ps1](./Compare-Gradient-Colorspaces.ps1)
- [ArgumentCompleter-For-RgbColor.ps1](./ArgumentCompleter-For-RgbColor.ps1) - Add **Pansies**'s `[RgbColor]` to your functions
- [Automatic BackgroundColors WithContrast.ps1](./AutoBackgroundColor-WithContrast.ps1) - Calculate background colors with contrast


**Examples**

![img](./screenshot/Compare-Gradient-Colorspaces.png)

From [Compare-Gradient-Colorspaces.ps1](./Compare-Gradient-Colorspaces.ps1)

![img](./screenshot/AutoBackgroundColor-WithContrast.png)

From [AutoBackgroundColor-WithContrast.ps1](./AutoBackgroundColor-WithContrast.ps1)

## Powershell 5.1

```ps1
Import-Module Pansies

function GetColor { 
    # WinPS5.1
    [CmdletBinding()]
    param(
        [ArgumentCompleter([PoshCode.Pansies.Palettes.X11Palette])]
        $Name
    )
    $Name
}

You can declare your functions with a `RGBColor` parameter, then [on module load it will register the ArgumentCompleter for all commands with RGBColor parameters](https://github.com/PoshCode/Pansies/blob/45ff80a8f6b4ae52a4d7c36cbeb91ca93b8ed3d1/Source/Pansies.psd1#L80-L84)
 