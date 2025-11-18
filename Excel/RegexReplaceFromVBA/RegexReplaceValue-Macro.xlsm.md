
About: Attempting to answer [this thread about Select.Extend being removed](https://learn.microsoft.com/de-de/answers/questions/5622494/november-11-update-breaks-vba-selection-extend)

I was able to write a VB macro that uses the new **Excel Regex Functions** from:

- https://techcommunity.microsoft.com/blog/microsoft365insiderblog/new-regular-expression-regex-functions-in-excel/4226334

Hopefully this reduces dependecies from modules that are being removed like older VB Regex solutions

```vba
Function RegexReplaceWith(original As String, pattern As String, replacement As String) As String
    Dim newText As String
    
    newText = Application.Evaluate("=REGEXREPLACE( """ & original & """, """ & pattern & """, """ & replacement & """ )")
    Debug.Print newText
    RegexReplaceWith = newText
End Function


Sub ReplaceTemplateWithParams()
'
' replace multiple patterns with a variable 

    Debug.Print Chr(10) & "Regex:" & Chr(10)
    ' simplest hardcoded version: Debug.Print Application.Evaluate("=REGEXREPLACE( ""hi world #username#"", ""#username#"", ""Jen"" )")

    Dim sel As String
    Dim newSel As String

    sel = ActiveCell.FormulaR1C1
    Debug.Print Chr(10) & sel
    
    newSel = sel
    Debug.Print "Start: " & newSel
    
    newSel = RegexReplaceWith(newSel, "#username#", "Jen")
    Debug.Print "    regex name = " & newSel
    
    newSel = RegexReplaceWith(newSel, "#date#", "2040-10-23")
    Debug.Print "    regex date = " & newSel

    ActiveCell.FormulaR1C1 = newSel
    
End Sub
```

## Excel Formula, No VB solution

```ts
= LET(
  source, A3,
  dateNow, TODAY(),
  renderDate, TEXT( dateNow, "yyyy-MM-dd" ),
  final, REGEXREPLACE( source, "#date#", renderDate, 0, 1),
  final
)
```

