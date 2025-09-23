<#
.SYNOPSIS
    See the difference in dynamic params based on the provider

    discord context: <https://discord.com/channels/180528040881815552/447476117629304853/1419833119426478234>
.LINK
    ./Export-AllProxyFunctionVariations.ps1
#>
$tobj = $ExecutionContext.InvokeCommand.GetCommand(
    'Microsoft.PowerShell.Management\Get-Item',
    [System.Management.Automation.CommandTypes]::Cmdlet, $PSBoundParameters )

"`n`nUsing 'cert:\'" | Write-Host -fore blue
pushd cert:\ -StackName 'dynamicParams'
($tobj.Parameters.GetEnumerator() | ?{ $_.Value.IsDynamic }).Value | Ft

popd -ea ignore -StackName 'dynamicParams'

<#
    Name                    ParameterType
    ----                    -------------
    CodeSigningCert         System.Management.Automation.SwitchParameter
    DocumentEncryptionCert  System.Management.Automation.SwitchParameter
    SSLServerAuthentication System.Management.Automation.SwitchParameter
    DnsName                 System.String
    Eku                     System.String[]
    ExpiringInDays          System.Int32
#>
"`n`nUsing 'C:\'" | Write-Host -fore blue
pushd c:\ -StackName 'dynamicParams'
($tobj.Parameters.GetEnumerator() | ?{ $_.Value.IsDynamic }).Value | Ft

popd -ea ignore -StackName 'dynamicParams'
# or:  $tobj.Parameters.GetEnumerator() | ?{ $_.Value.IsDynamic }

<#
output:
    Name   ParameterType   ParameterSets
    ----   -------------   -------------
    Stream System.String[] {[__AllParameterSets, System.Management.Automat
#>


function CollectRuntimeParams {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ArgumentCompletions('Microsoft.PowerShell.Management\Get-Item')]
        $Command = 'Microsoft.PowerShell.Management\Get-Item',

        [System.Management.Automation.CommandTypes] $CommandType = [System.Management.Automation.CommandTypes]::Cmdlet
    )

    # $targetCmd = $ExecutionContext.InvokeCommand.GetCommand(
    #     # $Command, [System.Management.Automation.CommandTypes]::Cmdlet, $PSBoundParameters )
    #     $Command, [System.Management.Automation.CommandTypes]::Cmdlet, @{} )
    $targetCmd = $ExecutionContext.InvokeCommand.GetCommand(
        # $Command, [System.Management.Automation.CommandTypes]::Cmdlet, $PSBoundParameters )
        $Command, $CommandType, @{} )

    if($null -eq $TargetCmd ) {
        'Command: {0}, Type: {1} was null for GetCommand!' -f @(
            $Command, $CommandType
        ) | Write-Warning
        return
    }

    $dynamicParams = @( $targetCmd.Parameters.GetEnumerator() | Microsoft.PowerShell.Core\Where-Object { $_.Value.IsDynamic } )
    $nonDynamic    = @( $targetCmd.Parameters.GetEnumerator() | Microsoft.PowerShell.Core\Where-Object { -not $_.Value.IsDynamic } )

    if ($dynamicParams.Length -gt 0) {
            $runtimeParams = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

            # [Management.Automation.RuntimeDefinedParameterDictionary] $pd_ctor = @{
            #     Data = 'some data'
            #     HelpFile = 'Help Str'
            # }

            foreach ($param in $dynamicParams) {
                $param = $param.Value

                if( -not $MyInvocation.MyCommand.Parameters.ContainsKey( $param.Name ) )
                {
                    $dynParam = [Management.Automation.RuntimeDefinedParameter]::new(
                        $param.Name, $param.ParameterType, $param.Attributes
                    )
                    $runtimeParams.Add( $param.Name, $dynParam )
                }
            }
            # $finalD = $runtimeParams
            # return $runtimeParams
        }

    $Info = [ordered]@{
        DynamicParams = $Dynamicparams
        NormalParams  = $nonDynamic
        TargetCommand = $targetCmd
        RuntimeParams = $runtimeParams
    }
    [pscustomobject]$Info
}


pushd 'c:\' -StackName 'dynamicParams'
$from_fs = CollectRuntimeParams -Command Microsoft.PowerShell.Management\Get-Item

pushd 'cert:\' -StackName 'dynamicParams'
$from_cert = CollectRuntimeParams -Command Microsoft.PowerShell.Management\Get-Item

popd -ea ignore -StackName 'dynamicParams'
popd -ea ignore -StackName 'dynamicParams'

'Cert Params and Attributes' | Write-Host -fore Blue

$from_cert.RuntimeParams.Values | Ft

@( $from_cert.RuntimeParams.Values).Attributes | % { $_.gettype() }

'Filesystem Params and Attributes' | Write-Host -fore Blue

$from_fs.RuntimeParams.Values | Ft

@($from_fs.RuntimeParams.Values).Attributes | % { $_.gettype() }

@'
## Try commands: ##


$from_fs.RuntimeParams.Values | Ft

$from_cert.RuntimeParams.Values | Ft

'@ | Write-Host -fore Blue


return
