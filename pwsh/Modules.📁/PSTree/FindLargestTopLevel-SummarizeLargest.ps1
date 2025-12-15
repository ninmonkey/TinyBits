#requires -PSEdition Core
#requires -Modules PSTree, Pansies



filter LabelIt {
    # Sugar: Label an object to the host, emit original object to the output-stream
    Pansies\New-Text -fg 'salmon' -bg 'gray30' "`n## Item: ${_} ##`n" | Pansies\Write-Host
    $_
}

# 🐒> find Largest parents
$where = gi 'G:\SteamLibrary\steamapps\common\'
$top = pstree -Depth 1 -RecursiveSize -Directory -Path $where
   | ? Fullname -notMatch 'demo'
   | Sort-Object Length -Descending  -Top 3

$top

# 🐒> then summarizes the top depth of each child, skipping the base dir
$top | Select-Object -Skip 1
     | LabelIt
     | pstree -Directory -Depth 1 -RecursiveSize
