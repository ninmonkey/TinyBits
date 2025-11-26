Properties {
    $x = 32
}

FormatTaskName {
    param( $taskName )
    "Executing Task: $taskName" | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor blue
}

Task TaskA {
    $x = -10
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Task       = 'TaskA'
        Method     = '$x'
        X          = $x
    }
}

Task TaskB {
    $x = -20
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Task       = 'TaskB'
        Method     = '$script:x'
        X          = $script:x
    }
}

Task TaskC {
    $script:x = -44
    $x = -30
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Task       = 'TaskC'
        Method     = '$x'
        X          = $x
    }
}

Task default -Depends TaskA, TaskB, TaskC
