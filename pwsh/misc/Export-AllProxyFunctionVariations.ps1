$StartIn = Get-Item -ea 'stop' 'G:\temp\2025-06-30\now\prox'

Push-Location -stack 'Proxy' $StartIn

$ExportBase = Join-path (Get-Item '.') './export'
$ExportBase = Get-Item -ea 'stop' $ExportBase


$ExportRoot = Join-Path $ExportBase 'func'
mkdir $ExportRoot -ea 'ignore'

$func      = Get-Command help -CommandType Function
$func_help = Get-Help $Func
$gcm       = gcm Get-Item
$gcm_help  = Get-Help $Func
try {
    if( 'export func' ) {
        # command invoked by 'help' in the proxy code is
        $wrapped = $ExecutionContext.InvokeCommand.GetCommand('help',
            [System.Management.Automation.CommandTypes]::Function )

        $wrapped.ScriptBlock
            | Set-Content -path (Join-Path $ExportRoot 'pager_func.ps1')

        [System.Management.Automation.ProxyCommand]::GetDynamicParam( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-DynamicParams.ps1')

        [System.Management.Automation.ProxyCommand]::Create( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Create.ps1')

        [System.Management.Automation.ProxyCommand]::Create($func, 'SomeHelpString', $false)
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Create_WithHelp.ps1')

        [System.Management.Automation.ProxyCommand]::Create($func, 'SomeHelpString', $true)
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Create_WithHelp_AndDynamic.ps1')

        [System.Management.Automation.ProxyCommand]::GetCmdletBindingAttribute( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-CmdletBindingAttribute.ps1')

        [System.Management.Automation.ProxyCommand]::GetBegin( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Block_Begin.ps1')

        [System.Management.Automation.ProxyCommand]::GetClean( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Block_Clean.ps1')

        [System.Management.Automation.ProxyCommand]::GetEnd( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Block_End.ps1')

        [System.Management.Automation.ProxyCommand]::GetParamBlock( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Block_ParamBlock.ps1')

        [System.Management.Automation.ProxyCommand]::GetProcess( $func )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-Block_Process.ps1')

        [System.Management.Automation.ProxyCommand]::GetHelpComments( $func_help )
            | Set-Content -path (Join-Path $ExportRoot 'proxyFunc-HelpFromObject.ps1')
    }
    if( 'export Cmdlet' ) {
        $ExportRoot = Join-Path $ExportBase 'cmdlet'
        mkdir $ExportRoot -ea 'ignore'
        # $func      = Get-Command Get-Item
        # $func      = gcm Get-Item
        # $func_help = Get-Help $Func

        # command invoked by 'help' in the proxy code is
        $wrapped = $ExecutionContext.InvokeCommand.GetCommand('Get-Item',
            [System.Management.Automation.CommandTypes]::Function )

        $wrapped.ScriptBlock
            | Set-Content -path (Join-Path $ExportRoot 'pager_func.ps1') -ea continue

        [System.Management.Automation.ProxyCommand]::GetDynamicParam( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-DynamicParams.ps1')

        [System.Management.Automation.ProxyCommand]::Create( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Create.ps1')

        [System.Management.Automation.ProxyCommand]::Create($gcm, 'SomeHelpString', $false)
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Create_WithHelp.ps1')

        [System.Management.Automation.ProxyCommand]::Create($gcm, 'SomeHelpString', $true)
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Create_WithHelp_AndDynamic.ps1')

        [System.Management.Automation.ProxyCommand]::GetCmdletBindingAttribute( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-CmdletBindingAttribute.ps1')

        [System.Management.Automation.ProxyCommand]::GetBegin( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Block_Begin.ps1')

        [System.Management.Automation.ProxyCommand]::GetClean( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Block_Clean.ps1')

        [System.Management.Automation.ProxyCommand]::GetEnd( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Block_End.ps1')

        [System.Management.Automation.ProxyCommand]::GetParamBlock( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Block_ParamBlock.ps1')

        [System.Management.Automation.ProxyCommand]::GetProcess( $gcm )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-Block_Process.ps1')

        [System.Management.Automation.ProxyCommand]::GetHelpComments( $gcm_help )
            | Set-Content -path (Join-Path $ExportRoot 'proxyCmdlet-HelpFromObject.ps1')

    }



    # [System.Management.Automation.ProxyCommand]::GetHelpComments( $func )
    # [System.Management.Automation.ProxyCommand]::GetHelpComments( [System.Management.Automation.ProxyCommand]::Create($func, 'SomeHelpString', $true) )
} catch {
    throw
} finally {
    Get-Location | % FullName | Join-String -op 'was in: '
    gci . *.ps1 -Recurse


    pop-Location -stack 'Proxy'
    Get-Location | % FullName | Join-String -op 'now in: '
}
