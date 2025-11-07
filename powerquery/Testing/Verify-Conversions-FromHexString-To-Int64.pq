let
    /*
    about: Converts hexadecimal numbers from "hex strings" like "ff"
    converting it to an Int64.Type

    inputs: { "ff", "1f", "Cat" }
        as type: text

    output: { 255, 31, error }
        as type: Int64.Type

    updated example from 2020 that originally came from from: https://xxlbi.com/blog/converting-hexadecimal-to-decimal-numbers-in-power-query/

    fixed the error that made it silently fail, returning a bad value
    */

    Number.FromHexText =
        ( Input as text, optional Base as number) as number => [
            Symbols       = { "0".."9" } & { "A".."F" },
            AsReverseList = List.Reverse( Text.ToList(Text.Upper(Input)) ),
            AsNumbers     = List.Transform(
                AsReverseList,
                (char) => [
                    pos = List.PositionOf( Symbols, char ),
                    return =
                        if pos <> -1 then pos
                        else error [
                            Message.Format = "Invalid character ""#{0}"" found in hex string ""#{1}"" when converting to Int64.",
                            Message.Parameters = { char, Input }
                        ]
                ][return]
            ),

            DigitConversion = List.Generate(
                () => 0,
                each _ < List.Count(AsNumbers),
                each _ + 1,
                each AsNumbers{_} * Number.Power(Base ?? 16, _)
            ),

            Return = Int64.From( List.Sum( DigitConversion ) )
        ][Return],


    Summary = [

        ShouldFail = Number.FromHexText("foo bar x"),

        sample_int = List.Distinct( { 255, 256, 32, 31, 15, 0x10ffffff, 0xff, 0x1f } ),
        results = List.Transform( sample_int,
                (num) => [
                    Passed   = Expected = Actual,
                    RawText  = Number.ToText( num, "x", "en-us" ),
                    Expected = num,
                    Actual   = Number.FromHexText( RawText )
                ]
            ),
        Source = Table.FromRecords( results, type table [
            Passed   = logical,
            RawText  = text,
            Expected = Int64.Type,
            Actual   = Int64.Type
        ], MissingField.Error )
    ],
    TestResults = Summary[Source]
in
    TestResults