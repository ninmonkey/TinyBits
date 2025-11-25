

## First Attack
```ps1
$return = Invoke-PSake .\BuildAndEmit.ps1
$return | ? { $_ -isnot [string] }
```

Output custom objects
```ps1

- [ ] [Collect tasks output by monsters](file:///./BuildAndEmit-2.ps1)

```

Filter to only have the custom PSCO type defined above 
```ps1
$return | ? { 'psake.info' -in  $_.PsTypeNames }
```

### Files

- `InvokeTask-BuildAndEmit-2`
- `BuildAndEmit-2`