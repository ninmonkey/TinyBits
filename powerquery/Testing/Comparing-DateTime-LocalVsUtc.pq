let
    Json = (src as any) => Text.FromBinary( Json.FromValue( src ) ),
    TestList = [

        now_dt  = DateTime.FixedLocalNow(),
        now_dtz = DateTimeZone.FixedLocalNow(),
        now_utc = DateTimeZone.FixedUtcNow(),

        dtz_min = #datetimezone( 2024, 1,19, 0, 0, 0, -14, 0 ),
        dtz_max = #datetimezone( 2024, 1,19, 0, 0, 0, 14, 0 ),

        dtz_min_utc = DateTimeZone.ToUtc( dtz_min ),
        d_min = DateTime.Date( dtz_min ),

        dtz_max_utc = DateTimeZone.ToUtc( dtz_max ),
        d_max = DateTime.Date( dtz_max )
    ],

    // expands tests to be more readable
    SummaryTable = [
        RawTable = Record.ToTable( TestList ),
        AddInfo = Table.AddColumn(
            RawTable,
            "Info",
            (row) =>
                row & [
                    TypeName = TypeName( row[Value] ),
                    AsDate   = DateTime.Date( row[Value] ),
                    AsTime   =
                        DateTime.Time( row[Value] ),
                    AsTime_Err =
                        let
                            maybeErr = try AsTime
                        in
                            if maybeErr[HasError] then
                                try AsTime
                                catch (err) => Json( err )
                            else ""
                ],
            Record.Type
        ),
        Drop_Cols = Table.SelectColumns( AddInfo, {"Info"} ),

        TakeColumnNames = { "Name", "Value", "TypeName", "AsDate", "AsTime", "AsTime_Err" },

        ExpandInfo = Table.ExpandRecordColumn(
            Drop_Cols, "Info", TakeColumnNames, TakeColumnNames ),

        WithTypes = Table.TransformColumnTypes(ExpandInfo,{
                {"Name", type text},
                {"TypeName", type text},
                {"AsDate", type date},
                {"AsTime", type time},
                {"AsTime_Err", type text}
            }),

        Return = WithTypes
    ],

    // get type names as a string
    TypeName = (value as any) as text =>
        if Value.Is( value, DateTime.Type ) then "DateTime"
        else if Value.Is( value, DateTimeZone.Type ) then "DateTimeZone"
        else if Value.Is( value, Date.Type ) then "Date"
        else if Value.Is( value, Time.Type ) then "Time"
        else if Value.Is( value, Duration.Type ) then "Duration"
        else if Value.Is( value, Table.Type ) then "Table"
        else if Value.Is( value, Record.Type ) then "Record"
        else "Other",

    FinalSummary = SummaryTable[Return]
in
    FinalSummary