let
    Source= ...,

    // grab the first row to clone
    // update specific columns without having to specify all columns
    clonedRecord  = Source{0},

    partialRecord = [
        Customer = "Jack",
        Product  = "Hat"
    ],
    newRecord        = Record.Combine( { clonedRecord, partialRecord } ),
    TableWithFakeRow = Table.InsertRows( Source, 0, {newRecord} )
in
    TableWithFakeRow
