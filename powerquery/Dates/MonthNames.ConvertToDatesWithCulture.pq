let
    // Sample data: Example that expands a simple table using `Table.FromParitions`
    Source = [
        return = Table.FromPartitions(
            "Culture",
            {
                { "en", wrapAsTable(en) },
                { "es", wrapAsTable(es) },
                { "de", wrapAsTable(de) }
            },
            type text
        ),

        wrapAsTable = ( rows as list ) as table =>
            #table(
                type table [ MonthName = text ],
                List.Transform( rows, (item) => { item }  )
                // {  List.Transform( rows, (item) => { item }  ) }
            ),

        en = {
            "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
        },
        es = { "enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre" },

        de = { "Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember" }
    ][return],

    // The only actual step: Convert using culture and format strings
    AddColumn_ToDate = Table.AddColumn(
        Source, "AsDate",
        (row) => Date.FromText( row[MonthName], [
            Format = "MMMM",
            Culture = row[Culture]
        ] ),
        type date
    )
in
    AddColumn_ToDate