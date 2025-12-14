[Back Up ⮥: CLI](./../README.md) [Back Up ⮥: Root](./../../README.md)

- [`git`](#git)
  - [`git log` with `--grep` / `--grep-reflog`](#git-log-with---grep----grep-reflog)
  - [`git grep` searching](#git-grep-searching)
    - [Show total matches per file](#show-total-matches-per-file)
    - [Search for look for "version" strings](#search-for-look-for-version-strings)
    - [Using null delimiter](#using-null-delimiter)
    - [Context / Function Context](#context--function-context)
    - [Other flags](#other-flags)

# `git`

note: Similar sounding commands are different
> [!NOTE]
> `git log --grep` and `git grep`

## `git log` with `--grep` / `--grep-reflog`

```ps1
🐒> git --no-pager log --oneline --grep="release"
🐒> git --no-pager log --oneline --grep-reflog="release" --walk-reflogs
```

## `git grep` searching

docs:
- [`git grep`](https://git-scm.com/docs/git-grep)
- [`git log`](https://git-scm.com/docs/git-log)

```ps1
🐒> git grep --perl-regexp --ignore-case 'unicode'

# ( the same using aliases )
🐒> git grep -P -i 'unicode'

# Word boundary and no recurse ( default is recurse )
🐒> git --no-pager grep -P -i --word-regexp --no-recurse 'unicode' 
```
### Show total matches per file
```ps1
🐒> git --no-pager grep -P -i --word-regexp --count 'unicode'
🐒> git --no-pager grep --line-number --count --only-matching -P -i '(todo|wip|nyi)' 
```
### Search for look for "version" strings
```ps1
🐒> git --no-pager grep --line-number --only-matching -P -i '(v(er)?.*?)(\d+[\d\.]+)' 
🐒> git --no-pager grep --line-number --only-matching -P -i '(v(er)?.*?)(\d+[\d\.]+)' 
```

### Using null delimiter

 instead of splitting by delim `:`, you can use `ansi null` `U+0000`. 
```ps1
🐒> foreach($line in (git --no-pager grep --line-number --null -P -i 'release') ) {     
        $line -replace '[\x00]', '🚀' 
    }
```

### Context / Function Context
```ps1
🐒> git --no-pager grep --line-number --function-context -P -i '(todo|nyi|wip)' 

🐒> git --no-pager grep --line-number --before=2 --after=2 -P -i '(todo|nyi|wip)' 
```

### Other flags

| Flag                   | Desc                                                                                                                                                                                 |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `-P`, `--perl-regexp`  | Perl Regex                                                                                                                                                                           |
| `-w`, `--word-regexp`  | Match the pattern only at word boundary (either begin at the beginning of a line, or preceded by a non-word character; end at the end of a line or followed by a non-word character) |
| `-v`, `--invert-match` | Select non-matching lines.                                                                                                                                                           |