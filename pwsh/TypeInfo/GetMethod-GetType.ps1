[String].GetMethod('Format', [type[]] ([string], [object[]]) ).GetType()

# Format has an array of overloads, but get type sees a single value
# Inspecting their types

[String]::Format.GetType()
@( [String]::Format ).GetType()
$( [String]::Format ).GetType()


