$cmd = "C:\Users\dgosbell\Downloads\DaxStudio_3_1_0_portable\dscmd.exe"
$server = "localhost:50909"
$database = "5389c85e-326d-4e8f-8e42-f2db2fcb98a4"

foreach ($letter in @("B", "R"))
{

    $query = @"
/* START QUERY BUILDER */
EVALUATE
SUMMARIZECOLUMNS(
    'Product'[Category],
    'Product'[Color],
    'Product'[Model],
    Reseller[Business Type],
    Customer[Country-Region],
    Customer[State-Province],
    KEEPFILTERS( FILTER( ALL( 'Product'[Color] ), SEARCH( \`"$letter\`", 'Product'[Color], 1, 0 ) = 1 )),
    \`"Total Sales\`", [Total Sales]
)
ORDER BY 
    'Product'[Category] ASC,
    'Product'[Color] ASC,
    'Product'[Model] ASC,
    Reseller[Business Type] ASC,
    Customer[Country-Region] ASC,
    Customer[State-Province] ASC
/* END QUERY BUILDER */
"@  

    &$cmd csv c:\temp\test-$letter.csv -s $server -d $database -q $query

}

# from: https://daxstudio.org/docs/features/command-line/powershell-examples/
https://daxstudio.org/docs/features/command-line/connecting/
https://www.connectionstrings.com/olap-analysis-services/
