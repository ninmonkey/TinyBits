# Examples using

## `gh repo view`

### Uses Json Fields, and then drills down as a string

```ps1
gh repo view --json=nameWithOwner --jq=.nameWithOwner
    # out: ninmonkey/TinyBits

gh repo view PowerShell/PowerShell
```

### View specific branch

```ps1
# view latest branch
gh repo view PowerShell/PowerShell

# view named branch
gh repo view PowerShell/PowerShell --branch='release/v7.4'
```

### Label - `gh issue`

```ps1
# subcmd help
gh issue --help
gh issue list --help
gh issue create --help
gh issue status --help

TinyBits.Gh.Label.List -RepoOwnerName 'PowerShell/PowerShell' -OutputAs PSCO -JsonFields 'color,name,description,isDefault' |Ft

# [2] Output: As PSCO table of objects
TinyBits.Gh.Label.List -RepoOwnerName 'PowerShell/PowerShell' -OutputAs Json -JsonFields 'color,name,description,isDefault' |
    ConvertFrom-Json | 
    Select-Object -First 7

# [3] Output: As JSON and select specific fields 
TinyBits.Gh.Label.List -RepoOwnerName 'PowerShell/PowerShell' -OutputAs PSCO -JsonFields 'color,name,description,isDefault' | 
```

```ps1
gh issue create # TUI
gh issue create --assignee @me --label 'Command' --title 'add: `Find-TypeName`'
```

```ps1
gh issue --help
gh issue status --help
```

### Issues - `gh issue`

```ps1
# subcmd help
gh label --help
gh label clone  --help
gh label create --help
gh label delete --help
gh label edit   --help
gh label list   --help
```

```ps1
gh label create # TUI


gh label list --repo SeeminglyScience/ClassExplorer

```