<#
.SYNOPSIS
    Visualize the shell integration for CWD
.description
    implemented clone dir from: https://learn.microsoft.com/en-us/windows/terminal/tutorials/new-tab-same-directory

#>

# to disable both:
$log1, $log2 = $false, $true

# enable just the 2nd one:
$log1, $log2 = $false, $true

$OriginalPrompt = $function:Prompt
'Saved $OriginalPrompt' | Write-Host -fg 'salmon'

function Prompt { @(
    "`n`n"
    $loc = $executionContext.SessionState.Path.CurrentLocation
    if($script:log1) {  $loc | Write-Host -fg 'red' }

    [string] $str = ''
    if ($loc.Provider.Name -eq "FileSystem") {
            $str += "`e]9;9;`"$($loc.ProviderPath)`"`e\"
    }
    $str += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
    $str
    if( $script:log2 ) {  $str -replace "`e", '␛' | Write-Host -fg 'green' -NoNewline }
) | Join-String -sep "`n" }
