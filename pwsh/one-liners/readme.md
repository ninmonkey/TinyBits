# About Insanity

These aren't "true" one-liners
but
They should be mostly stand-alone drop-ins, as **one statement** into your session
If you have:

- `pwsh` and `pansies`


## Dumping History to a file

### Core Template

Expanded version, before stripping lines / oneline-ify
```ps1
$HistFileName = 'open-editors-stack.md'; 
( (Get-Clipboard -Raw) -split '\r?\n' | gi -ea 0 | Sort-Object LastWriteTime -Descending | % FullName ) 
    | Add-content -Path ( $histFileFullName = (Join-Path 'H:\data\2025\History.📁' $HistFileName ) ) -PassThru; 
New-Hyperlink -uri $histFileFullName $HistFileName 
    | Join-String -f "{0}" -op ( 'Saving open-editors history [2025-11-iter1] ' | New-Text -fg 'gray40' -bg 'gray20' ) 
    | write-host -fg gray30 -bg gray15 ;
```

### Quickly dump `0x1`: some `EverythingSearch` queries
```ps1
$HistFileName = 'everything-search-stack.md'; <# 1line-ish macro: 2025-11 #> ( (Get-Clipboard -Raw) -split '\r?\n' ) | Add-content -Path ( $histFileFullName = (Join-Path 'H:\data\2025\History.📁' $HistFileName ) ) -PassThru; New-Hyperlink -uri $histFileFullName $HistFileName | Join-String -f "{0}" -op ('Saving open-editors history [2025-11] '|New-Text -fg 'gray40' -bg 'gray20') | write-host -fg gray30 -bg gray15 ;
```
```ps1 
Get-Content $histFileFullName 
# output:
# dm:last4months !ext:js ext:code-workspace;js;html;ps1;psm1 dm:last12months !path:ww:"temp"  ( NotVenv: ) ( NotSpam: ) ( NotLocalAppDataApps: ) ( NotProgramFiles: ) ( NotSteamApps: ) ( !path:"github_fork" !path:"h:\data\2025\*🍴*" ) ( !path:"h:\out-session" )
```

### Quickly dump `0x2`: some `open editors` paths

```ps1
$HistFileName = 'open-editors-stack.md'; ( (Get-Clipboard -Raw) -split '\r?\n' | gi -ea 0 | Sort-Object LastWriteTime -Descending | % FullName ) | Add-content -Path ( $histFileFullName = (Join-Path 'H:\data\2025\History.📁' $HistFileName ) ) -PassThru; New-Hyperlink -uri $histFileFullName $HistFileName | Join-String -f "{0}" -op ( 'Saving open-editors history [2025-11-iter1] ' | New-Text -fg 'gray40' -bg 'gray20' ) | write-host -fg gray30 -bg gray15 ;
```

### Quickly dump `0x3`: some `folder` filepaths

```ps1
$HistFileName = 'paths-stack.md'; ( Get-Location | gi -ea 0 -ev 'lastHistError' | Sort-Object LastWriteTime -Descending | % FullName ) | Add-content -Path ( $histFileFullName = (Join-Path 'H:\data\2025\History.📁' $HistFileName ) ) -PassThru;  New-Hyperlink -uri $histFileFullName $HistFileName  | Join-String -f "{0}" -op ( 'Saving path[s] history [2025-11-iter1] ' | New-Text -fg 'gray40' -bg 'gray20' ) | write-host -fg gray30 -bg gray15 ; $lastHistError | Join-String -sep "`n" | write-host -fg 'salmon';
```
