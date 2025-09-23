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
pushd cert:\
($tobj.Parameters.GetEnumerator() | ?{ $_.Value.IsDynamic }).Value | Ft

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

pushd c:\
($tobj.Parameters.GetEnumerator() | ?{ $_.Value.IsDynamic }).Value | Ft
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
        $Command = 'Microsoft.PowerShell.Management\Get-Item'
    )

    $targetCmd = $ExecutionContext.InvokeCommand.GetCommand(
        $Command, [System.Management.Automation.CommandTypes]::Cmdlet, $PSBoundParameters )

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
        TargetCommand = $targetCommand
        RuntimeParams = $runtimeParams
    }
    [pscustomobject]$Info
}

return

$finalD        = [ordered]@{}
$dynamicParams = @()
$nonDynamic    = @()
 try {
        $targetCmd = $ExecutionContext.InvokeCommand.GetCommand(
            'Microsoft.PowerShell.Management\Get-Item',
            [System.Management.Automation.CommandTypes]::Cmdlet, $PSBoundParameters )

        $dynamicParams = @( $targetCmd.Parameters.GetEnumerator() | Microsoft.PowerShell.Core\Where-Object { $_.Value.IsDynamic } )
        $nonDynamic = @( $targetCmd.Parameters.GetEnumerator() | Microsoft.PowerShell.Core\Where-Object { -not $_.Value.IsDynamic } )

        if ($dynamicParams.Length -gt 0)
        {
            $paramDictionary = [Management.Automation.RuntimeDefinedParameterDictionary]::new()

            [Management.Automation.RuntimeDefinedParameterDictionary] $pd_ctor = @{
                Data = 'some data'
                HelpFile = 'Help Str'
            }

            foreach ($param in $dynamicParams)
            {
                $param = $param.Value

                if(-not $MyInvocation.MyCommand.Parameters.ContainsKey($param.Name))
                {
                    $dynParam = [Management.Automation.RuntimeDefinedParameter]::new($param.Name, $param.ParameterType, $param.Attributes)
                    $paramDictionary.Add($param.Name, $dynParam)
                }
            }
            $finalD = $paramDictionary

            return $paramDictionary
        }
    } catch {
        throw
    }
