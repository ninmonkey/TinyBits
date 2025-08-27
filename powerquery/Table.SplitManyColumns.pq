let
    // Source = Excel.CurrentWorkbook(){[Name = "RawStagingTable"]}[Content],
    Source = Table.FromRecords( {
        [ Customer = "Bob;2", Product = "Shoes;4" ],
        [ Customer = "Jen;1", Product = "Hat;8" ]
    } ),

    #"Raw Table" = Table.TransformColumnTypes(Source, { {"Customer", type text}, {"Product", type text} } ),

    ColumnNames_WithDelim = Table.ColumnNames( #"Raw Table" ),

    /*
    example:
        SplitColumnPairs( Source, "Customer", ";" )

    Splits the table column:

        { [ Customer = "Jen;64" ] }

    Into two columns:

        { [ Customer = "Jen", #"Customer Value" = 64 ] }

    Note: Column type is Int64 by default. Pass any "type" to override.

        SplitColumnPairs( source, "Names",      ";", type text ),
        SplitColumnPairs( source, "Inventory",  ";", type number ),
        SplitColumnPairs( source, "Sale",       ";", Currency.Type  ),
    */
    SplitColumnPairs = (source as table, columnName as text, delimiter as text, optional valueColumnType as nullable type )
        as table => [
            splitByFunc     = Splitter.SplitTextByEachDelimiter( { delimiter }, QuoteStyle.Csv, true ),
            columnValueName = columnName & " Value",

            AfterColSplit   = Table.SplitColumn( source, columnName, splitByFunc,
                { columnName, columnValueName }, null,  ExtraValues.Error ),

            return          = Table.TransformColumnTypes(AfterColSplit,{
                { columnName, type text }, { columnValueName, valueColumnType ?? Int64.Type }
            })
        ][return],

    AfterSplitManyCols = List.Accumulate(
        ColumnNames_WithDelim,
        #"Raw Table",
        ( state, current ) =>
            SplitColumnPairs( state, current, ";" )
    )

in  AfterSplitManyCols