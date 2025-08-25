# Inspecting the TypeData of Turtle


```ps1
Install-Module Turtle -Verbose
$mod = Import-Module Turtle

$turtle.PSTypeNames -contains 'Turtle'
$turtle -is [PSModuleInfo]
    # Turtle is actually pointing to extra typedata defined on the module object

[Object]::Equals( $mod, $turtle ) # True
```

## How to Build TypeData from the source

```ps1
gh repo clone gh repo clone PowerShellWeb/Turtle
cd Turtle

# rebuild FormatData and TypeData using EzFormat
. .\Build\Turtle.ezout.ps1

# running build updates the file: "Turtle.types.ps1xml"

# remove existing refs before loading new types and import the new version
Remove-Module 'Turtle' -ea ignore
$mod = Import-Module .\Turtle.psd1 -Verbose -PassThru

# Inspect the new version
$mod | Get-Member
Get-TypeData -TypeName Turtle
```

## ExportedCommands, ExportedVariables, TypesToProcess defined by `.psd1`

```ps1
$mod.ExportedCommands.Values | Ft -AutoSize

<# out:
    CommandType Name                 Version Source
    ----------- ----                 ------- ------
    Function    Get-Turtle           0.1.6   Turtle
    Function    Move-Turtle          0.1.6   Turtle
    Function    New-Turtle           0.1.6   Turtle
    Function    Save-Turtle          0.1.6   Turtle
    Function    Set-Turtle           0.1.6   Turtle
    Alias       turtle -> Get-Turtle 0.1.6   Turtle #>

$mod.ExportedVariables.Values | Ft -AutoSize

<# out:
    Name   Value
    ----   -----
    Turtle <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0
    #>
    
```

## Get-TypeData
```ps1
Import-Module Turtle -Verbose
$turtleType = Get-TypeData -TypeName Turtle
```
## Properties as methods

```ps1
> $turt = Get-Turtle
> $turt.PSTypeNames

# out: Turtle, PSCustomObject

# There are lots of properties and methods defined by 'TypesToProcess' 
$turt | Get-Member 
    | Join-String Name ', '


$turt | Get-Member 
( $turt | Get-Member ViewBox ).Definition 
    | Bat -l ps1 # 'bat' command will syntax highlight when piping to it    


($turtle | gm 'X').Definition | bat -l ps1
<#
───────┼────────────────────────────────────────────────────
   1   │ System.Object X {get=$this.Position.X;}
───────┴────────────────────────────────────────────────────
#>

( $turt | Get-Member ViewBox ).Definition

<# out:
System.Object ViewBox {get=if ($this.'.ViewBox') { return $this.'.ViewBox' }

$viewX = $this.Maximum.X + ($this.Minimum.X * -1)
$viewY = $this.Maximum.Y + ($this.Minimum.Y * -1)

return 0, 0, $viewX, $viewY;set=param(
[double[]]
$viewBox
)

if ($viewBox.Length -gt 4) {
    $viewBox = $viewBox[0..3]
}
if ($viewBox.Length -lt 4) {
    if ($viewBox.Length -eq 3) {
        $viewBox = $viewBox[0], $viewBox[1], $viewBox[2],$viewBox[2]
    }
    if ($viewBox.Length -eq 2) {
        $viewBox = 0,0, $viewBox[0], $viewBox[1]
    }
    if ($viewBox.Length -eq 1) {
        $viewBox = 0,0, $viewBox[0], $viewBox[0]
    }
}

if ($viewBox[0] -eq 0 -and
    $viewBox[1] -eq 0 -and
    $viewBox[2] -eq 0 -and
    $viewBox[3] -eq 0
) {
    $viewX = $this.Maximum.X + ($this.Minimum.X * -1)
    $viewY = $this.Maximum.Y + ($this.Minimum.Y * -1)
    $this.psobject.Properties.Remove('.ViewBox')
    return
}

$this | Add-Member -MemberType NoteProperty -Force -Name '.ViewBox' -Value $viewBox;}
#>
```