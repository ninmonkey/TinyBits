Properties {
    $x = 32
}

FormatTaskName {
    param( $taskName )
    "Executing Task: $taskName" | Microsoft.PowerShell.Utility\Write-Host -ForegroundColor blue
}

Task TaskA {
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Task       = 'TaskA'
        Method     = '$x'
        X          = $x
    }
}

Task TaskB {
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Task       = 'TaskB'
        Method     = '$script:x'
        X          = $script:x
    }
}

Task TaskC {
    [PSCustomObject]@{
        PSTypeName = 'psake.info'
        Task       = 'TaskC'
        Method     = '$x'
        X          = $x
    }
}

Task default -Depends TaskA, TaskB, TaskC
