$scriptblock = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )

    $results = @( 'cat', 'dog' )

    # What is the command one segment before me?
    if( $commandAst.CommandElements[-1].value -eq 'cat' )  {
        $results = @( 'tiger', 'lion' )
    }
    if( $commandAst.CommandElements[-1].value -eq 'dog' )  {
        $results = @( 'snoopy' )
    }
    @(
        $results
        | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_,               # completionText
                $_,               # listItemText
                'ParameterValue', # resultType
                $_                # toolTip
            )
        }
    )
}

Register-ArgumentCompleter -Native -CommandName nix -ScriptBlock $scriptblock

<#
you can complete:

    nix <tab>
    nix cat <tab>
    nix dog <tab>
    nix cat <tab> dog <tab>
    nix <tab> <tab>
#>
