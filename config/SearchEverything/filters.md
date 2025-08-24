

# About

SearchEverything filters

Patterns are set to use:

- ` ` space is a **boolean-AND**
- `|` pipe is a **boolean-OR**

## Default Ignores: Program files / Apps

```bat
(
    !path:ww:"%LocalAppData%"
    !path:"%UserProfile%\.vscode"
    !path:ww:".vscode"
    !path:ww:"Program Files" 
    !path:ww:"Mozilla\Firefox"
    !path:ww:"OneDrive" 
    !path:"Recycle.bin"
    !path:ww:"c:\windows"
)
```

Others:

```bat
( 
    !path:ww:"%AppData%"
)
```

## venv / virtual env

```bat
( 
    !path:ww:node_modules
)

```

## Python
```bat
( 
    !path:ww:"__pycache__"
    !path:ww:".mypy_cache" 
    !path:ww:".mypyls" 
)

```

## Misc

### Regex Date

find `YYYY-MM-DD` that uses any delimiter in `"- _" `
```bat
( file:regex:"\d{2,4}[- _]+\d{1,2}[- _]+\d{1,2}" )
```

### Regex: Web / Map files 

```bat
( regex:"\.min\.(js|css)(\.map)?$"  )
```

### Shell

```bat
shell:desktop
```

## Filetype Groups / By Kinds

### Ignores
```bat
(
    file:ww:".gitignore" | file:"*ignore"
)
```

### Vs Code

```bat
( ext:code-workspace;code-snippets;json | !path:ww:".vscode" )
```

### Power BI

```bat
( ext:pbix;pbit;pbip;pbir;pbi;xlsx;bism;bim;sql;pq;m )
```

### Excel
```bat
( ext:xlsx;xls;xlxm;xlsb;xlsm;csv;json )
```

### Git repos


```bat
( wfn:".git" )
```

### is Temp File

```bat
( file:regex:"^~\$.*\.(pbix|xlsx)$" | path:ww:TempSaves | path:ww:"$Recycle.Bin" )
```