
## About

Searching PSReadLine Functions by name, description, or keybindings


## Docs

- A list of all functions: [about_PSReadLine](https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline_functions?view=powershell-7.5)
- [Get-PSReadLineKeyhandler](https://learn.microsoft.com/en-us/powershell/module/psreadline/get-psreadlinekeyhandler?view=powershell-7.5)

## Examples

> [!NOTE]
> If you are using `WinPS <= 5.1`, you need to move the `|` to the previous line like this:

```ps1
Get-PSReadLineKeyHandler -Unbound -Bound | 
    ? Function -Match 'Accept|line|insert'
```

- [Show-PSReadlineKeyBind.ps1](./Show-PSReadlineKeyBind.ps1)

### Search by: Description

```ps1
Get-PSReadLineKeyHandler -Unbound -Bound
   | ? Description -Match 'insert|line|enter'
   | Sort-Object Function
   | ft Key, Function, Description
```

### Search by: Function name

```ps1
Get-PSReadLineKeyHandler -Unbound -Bound
   | ? Function -Match 'Accept|line|insert'
   | Sort-Object Function
   | ft Key, Function, Description
```

### Search by: Description and Functions
```ps1
Get-PSReadLineKeyHandler -Unbound -Bound 
   | ?{ 
      ( $_.Description -Match 'insert|line|enter'  ) -or 
      ( $_.Function    -Match 'Accept|line|insert' )
   }
   | Sort-Object Function
   | ft Key, Function, Description
```

### Search by: Is Not Currently Bound

```ps1
Get-PSReadLineKeyHandler -Unbound
    | Sort-Object Function
    | ft Key, Function, Description
```

### Skipping `Vi*` Commands

```ps1
Get-PSReadLineKeyHandler -Unbound
    | ? Function -NotLike 'Vi*' # if you want to skip Vi
    | Sort-Object Function
    | ft Key, Function, Description
```

