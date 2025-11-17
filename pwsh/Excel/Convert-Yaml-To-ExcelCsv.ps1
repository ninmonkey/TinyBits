#requires -Modules YaYaml
#requires -Version 7

<#
.synopsis
    Build a yaml example, then convert to csv for excel
.NOTES
    Tip: Save your .csv files as **UTF8 With a BOM marker**.

    Excel uses that detect the right encoding. columns like 'NativeName' will not import correctly
    ( by default. Unless you tell Excel / PowerQuery to use the right encoding. )
#>

$cult = Get-Culture -ListAvailable
$propsToIgnore = @(
    'Parent', 'CompareInfo', 'TextInfo', 'IsNeutralCulture', 'CultureTypes',
    'NumberFormat', 'DateTimeFormat', 'Calendar', 'OptionalCalendars',
    'UseUserOverride', 'IsReadOnly'
)

$path_yml = 'temp:\yaml-culture.yml'
$path_csv = 'temp:\yaml-culture.csv'
$cult
    # optionally exclude columns
    | Select-Object -ExcludeProperty $propsToIgnore -ea SilentlyContinue
    | YaYaml\ConvertTo-Yaml
    | Set-Content -Path $path_yml # -PassThru if you want to preview it

$data = YaYaml\ConvertFrom-Yaml -InputObject (
    Get-Content -Raw $path_yml
)

$data
    | ConvertTo-Csv
    | Set-Content -path $path_csv -Encoding utf8BOM # -PassThru if you want to preview it

Get-Item $path_csv | Invoke-Item
