[Back Up ⮥: CLI](./../README.md) [Back Up ⮥: Root](./../../README.md)

- [`git`](#git)
  - [`git tag`](#git-tag)
    - [misc examples](#misc-examples)
    - [annotated tag](#annotated-tag)
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

top level docs:
- [`git tag`](https://git-scm.com/docs/git-tag) [examples](https://git-scm.com/docs/git-tag#_examples)
- [`git grep`](https://git-scm.com/docs/git-grep) [examples](https://git-scm.com/docs/git-grep#_examples)
- [`git log`](https://git-scm.com/docs/git-log) [examples](https://git-scm.com/docs/git-log#_examples)


## `git tag`

```ps1
git --no-pager tag --list

git tag -a 'tag_name' -m 'message'
```
### misc examples

Select a few tags, and show the 10 most recent commits for each
```ps1
( $pk_version = git --no-pager tag --list | fzf -m )
foreach($cur in $pk_version ) { 
    $cur | Pansies\Write-Host -bg 'salmon' -fg 'steelblue4'
    git --no-pager log $cur --oneline -n 10
}
```


### annotated tag

```ps1
> git tag -a 'tag_name' -m 'message'
> git push origin 'tag_name'
```

## `git log` with `--grep` / `--grep-reflog`

docs:
- [`git tag`](https://git-scm.com/docs/git-tag) [examples](https://git-scm.com/docs/git-tag#_examples)
- [`git grep`](https://git-scm.com/docs/git-grep) [examples](https://git-scm.com/docs/git-grep#_examples)
- [`git log`](https://git-scm.com/docs/git-log) [examples](https://git-scm.com/docs/git-log#_examples)

```ps1
🐒> git --no-pager log --oneline --grep="release"
🐒> git --no-pager log --oneline --grep-reflog="release" --walk-reflogs
```

## `git grep` searching

docs:
- [`git grep`](https://git-scm.com/docs/git-grep) [examples](https://git-scm.com/docs/git-grep#_examples)
- [`git log`](https://git-scm.com/docs/git-log) [examples](https://git-scm.com/docs/git-log#_examples)

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