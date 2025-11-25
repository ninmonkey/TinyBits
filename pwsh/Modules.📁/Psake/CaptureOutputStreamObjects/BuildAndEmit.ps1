Task default -Depends TaskA, TaskB, TaskC

Properties {
    $x = 512
}

FormatTaskName {
    param($taskName)
    Write-Host "Executing Task: $taskName" -ForegroundColor blue
}

Task TaskA {
    'TaskA is executing'
}

Task TaskB {
    'TaskB is executing'
}

Task TaskC {
    'TaskB is executing'
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Name       = $Name
        Num        = $x
    }
}
