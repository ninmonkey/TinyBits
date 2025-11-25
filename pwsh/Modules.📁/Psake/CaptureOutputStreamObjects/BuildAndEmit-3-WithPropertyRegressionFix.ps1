Task default -Depends TaskA, TaskB, TaskC, TaskD

Properties {
    $script:Name = 'BobGlobal'
    $script:Num = 34
}

FormatTaskName {
    param($taskName)
    Write-Host "Executing Task: $taskName" -ForegroundColor blue
}

Task TaskA {
    'TaskA is executing'
    $script:Num += 3000
    $Name = 'Ted, Local Name'
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $Name
        Num        = $script:x
        Desc       = 'From A'
    }
}

Task TaskB {
    'TaskB is executing'
    $script:Num += 6000
    # this time replace script-scope instance of the variable
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $script:Name
        Num        = $script:Num
        Desc       = 'From B'
    }
}

Task TaskC {
    'TaskC is executing' | Write-verbose
    $script:Num = 100
    # $script:Name = 'A`nonymous'
    $script:name = 'Anonymous'
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $script:Name
        Num        = $script:Num
        Desc       = 'From C'
    }
}
Task TaskD {
    'TaskD is executing' | Write-verbose
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $script:Name
        Num        = $script:Num
        Desc       = 'From D'
    }
}
