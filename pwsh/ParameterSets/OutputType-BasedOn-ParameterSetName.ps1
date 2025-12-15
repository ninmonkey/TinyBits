function H1 {
    [OutputType( [System.Void], ParameterSetName = '__AllParameterSets' )]
    [OutputType( [PoshCode.Pansies.Text], ParameterSetName = 'OutObject' )]
    [CmdletBinding( DefaultParameterSetName = '__AllParameterSets')]
    param(
        # [Parameter(Mandatory, Position = 0, ParameterSetName = '__AllParameterSets')]
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'OutObject')]
        [string] $Text,

        # Instead of writing to host, return result of (New-Text)
        [Parameter(Mandatory, ParameterSetName = 'OutObject')]
        [switch] $PassThru
    )
    $obj = $Text | Pansies\New-Text -Fg 'gray40' -bg 'gray20'
    if( $PassThru ) { return $Obj }
    $Obj | Write-Host
}

H1 'sdfds'

H1 'sdfds' -PassThru
    | Write-Verbose -Verbose

H1 'sdfds' -PassThru
    | Write-Host

(Gcm h1).OutputType |ft -AutoSize
<#
    Name                  Type
    ----                  ----
    System.Void           System.Void
    PoshCode.Pansies.Text PoshCode.Pansies.Text
#>
return
( h1 'sdfdfs' -PassThru)#.<Tab>
    # 👍 : Generates correct [Pansies.Text] completions

( h1 'sdfdfs')#.<Tab>
    # 🙈 : Instead of nothing, generates [Pansies.Text] completions
