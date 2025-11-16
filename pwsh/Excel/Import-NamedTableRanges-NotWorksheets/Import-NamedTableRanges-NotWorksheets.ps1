#requires -Modules ImportExcel, Pansies

$path_import = Join-Path $PSScriptRoot './Example.xlsx'

if ( $null -ne $Pkg ) {
    Close-ExcelPackage $Pkg
    $pkg = $Null
}

$Pkg = Open-ExcelPackage -Path $path_import

'Found worksheets: {0}' -f @( $pkg.Workbook.Worksheets.Name -join ', ' ) |
    Pansies\Write-Host -fore salmon

$pkg.Workbook.Worksheets | ForEach-Object tables | ForEach-Object {
    $curTable = $_
    'Found tables: sheet: {0}, table: {1}, addr: {2}' -f @(
        $curTable.WorkSheet
        $curTable.Name
        $curTable.Address
    ) | Pansies\Write-Host -fore 'salmon'
}

$table = $pkg.workbook.Worksheets.tables | Where-Object  Name -eq 'Animals'

# Grab just the table. formatting and column types should be preserved this way
$data =  Import-Excel -Path $path_import -WorksheetName 'OffsetTable' -StartRow $table.Address.Start.Row -StartColumn $table.Address.Start.Col

$data
