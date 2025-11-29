<#
.SYNOPSIS
    Experimenting with metadata in CIM modules
#>
$error.clear()
$mod_root = Import-Module 'MMAgent' -PassThru -ea 'stop'
$mod_root.ExportedCommands.Values | Format-Table -auto

$mod_inner = $mod_root.NestedModules
$mod_inner.ExportedCommands.Values | Format-Table -AutoSize

# drill down
$cmd = $mod_inner.ExportedCommands['Get-MMAgent']

$cmd | Format-List Source, Name, CommandType, OutputType


# Cim types are wrappers. Showing the first chunk
($cmd.Definition) -split '\r?\n' | Select-Object -First 20 -Skip 15


$cmd.OutputType | ft Name, Type -AutoSize

# Explicitly load inner module
$mod_cdxml = Import-Module $mod_root.NestedModules.Path -Passthru -Verbose

( $all_ciminst_tinfo = Get-TypeData -TypeName '*CimInstance*' ).count

$cmd_cdxml = $mod_cdxml.ExportedCommands['Enable-MMAgent']

# check out .ScriptBlock, and .Definition
($query_cim ??= Get-CimClass -ClassName PS_MMAgent -Namespace "Root\Microsoft\Windows\PS_MMAgent" )

'## Properties of $query_cim' | Write-Host -fore darkyellow
# $query_cim | ShortProps -Basic |Ft Name, Value, TypeNameOfValue
$query_cim.psobject.properties | Ft Name, Value, TypeNameOfValue


'## CimClassMethods of $query_cim' | Write-Host -fore darkyellow
$query_cim.CimClassMethods

'## Class and namespace' | write-host -fore darkyellow
$query_cim.CimSystemProperties | Ft NameSpace, ClassName


$xml_path = 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\MMAgent\ps_mmagent_v1.0.cdxml'
[xml] $doc = gc -raw $xml_path

'## Class and namespace from **XML**' | write-host -fore darkyellow

$doc.PowerShellMetadata.Class.ClassName

$doc.PowerShellMetadata.Class.PowerShellMetadata
