

$target = Get-Item -ea 'stop' '..\Pwsh-Snippets-2025.📁.code-workspace'
[System.IO.Path]::GetRelativePath( 'h:\data\2025\pwsh', $target )
    # ㏒: snippets📁\Pwsh-Snippets-2025.📁.code-workspace

[System.IO.Path]::GetRelativePath( $env:UserProfile, $env:AppData )
    # ㏒: AppData\Roaming

$here = Get-Item .
$up   = Get-Item ..
$path = Get-Item '.\color\Prefix.Polyfilll-WriteLable.ps1'

[System.IO.Path]::GetRelativePath( '..', $path )
    # TinyBits\pwsh\color\Prefix.Polyfilll-WriteLable.ps1

[System.IO.Path]::GetRelativePath( '../..', $path )
    # GitRepos.🐒\TinyBits\pwsh\color\Prefix.Polyfilll-WriteLable.ps1



$path = Get-Item 'foo/bar.ps1' -ea 'stop'
[System.IO.Path]::GetRelativePath( (Get-Item ..), $path )
[System.IO.Path]::GetRelativePath( '.', $path )
[System.IO.Path]::GetRelativePath( '..', $path )
