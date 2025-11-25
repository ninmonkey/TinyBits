Task default -Depends TaskA, TaskB, TaskC, TaskD

Properties {
    $x = 512
}

FormatTaskName {
    param($taskName)
    Write-Host "Executing Task: $taskName" -ForegroundColor blue
}

Task TaskA {
    'TaskA is executing'
    $script:x += 3000
    $Name = 'Ted'
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $Name
        Num        = $script:x
        Desc = 'From C'
    }
}

Task TaskB {
    'TaskB is executing'
    $script:x += 6000
    # this time replace script-scope instance of the variable
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $script:Name
        # Num        = $script:x
        Desc = 'From C'
    }
}

Task TaskC {
    'TaskC is executing' | Write-verbose
    $script:x = 100
    # $script:Name = 'A`nonymous'
    $name = 'Anonymous'
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $script:Name
        Num        = $script:x
        Desc = 'From C'
    }
}
Task TaskD {
    'TaskD is executing' | Write-verbose
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $script:Name
        Num        = $script:cat
        Desc       = 'From D'
    }
}
