```ps1
git rev-parse --show-toplevel
git rev-parse --git-common-dir
git rev-parse --git-dir --git-common-dir


git status -z
git config --get commit.template
( git status -z -uall) -split "`u{0}"


git for-each-ref '--format=%(refname)%00%(upstream:short)%00%(objectname)%00%(upstream:track)%00%(upstream:remotename)%00%(upstream:remoteref)'

git for-each-ref '--format=%(refname)%00%(upstream:short)%00%(objectname)%00%(upstream:track)%00%(upstream:remotename)%00%(upstream:remoteref)' --ignore-case refs/heads/main refs/remotes/main

```

try `-z` 
```ps1
pushd 'G:\2021-github-downloads\Apps\CommandLine\fd'
( git log HEAD --date=raw --max-count=13 --skip=0 -z '--format=%H%x00%h%x00%s%x00%b%x00%an <%ae> %ad%x00%cn <%ce> %cd%x00%P%x00%(trailers:unfold,only)%x00%D' --no-show-signature ) -replace "`u{0}", '🦎' # --color=always

( git log HEAD --date=raw --max-count=13 --skip=0 '--format=%H%x00%h%x00%s%x00%b%x00%an <%ae> %ad%x00%cn <%ce> %cd%x00%P%x00%(trailers:unfold,only)%x00%D' --no-show-signature ) -replace "`u{0}", '🦎' # --color=always

```

```ps1
pushd 'G:\2021-github-downloads\Apps\CommandLine\fd'
git log -g --no-abbrev-commit --pretty=oneline HEAD -n 2500
git log --no-abbrev-commit --pretty=oneline HEAD -n 3
```

### Git `config` 

```ps1
git config --get core.longpaths # true
git config --get core.quotepath # null
git config --get color.ui # null
git config --get commit.template # null ? 
```

### rev-parse
```ps1
pushd 'G:/2021-github-downloads/Apps/CommandLine/fd/src'

git rev-parse --git-common-dir
    # ../.git

git rev-parse --git-dir
    # G:/2021-github-downloads/Apps/CommandLine/fd/.git


git rev-parse --show-toplevel
    # G:/2021-github-downloads/Apps/CommandLine/fd
```

### ShortLog

```ps1
git shortlog --since=10.week.ago
```

```ps1
> git log --since=7.year.ago --pretty=oneline

> git shortlog -s --all --no-min-parents --since=1.year.ago

    #      1  Andreas Stergiopoulos
    #      3  Benjamin A. Beasley
    #      1  Bzero
    #      1  Daniel Hast
    #      2  David Peter
    #      1  Josef Andersson
    #      1  Josh Cotton
    #      4  Neal S
    #      1  Sambhram
    #      4  Shun Sakai
    #      4  Sivaram Kannan
    #     19  Tavian Barnes
    #    102  Thayne McCombs
    #      1  Vilius Panevėžys
    #     54  dependabot[bot]
    #      1  jaideepkathiresan
    #      2  n4n5
    #      1  ritoban23
    #      1  tkb-github

```
### another 
```ps1
git log -g --no-abbrev-commit --pretty=oneline HEAD -n 2500

git log --format=%H%n%aN%n%aE%n%at%n%ct%n%P%n%D%n%B -z --shortstat --diff-merges=first-parent -n50 --skip=0 --topo-order --decorate=full

```
```log
ac4ded5b2700890c75f9cf474c1838aa4368807a (HEAD -> master) HEAD@{0}: clone: from https://github.com/sharkdp/fd.git
---------------------------------------------------------------------------------------------------------------------
```
```ps1
git log --no-abbrev-commit --pretty=oneline HEAD -n 3
```
```log
ac4ded5b2700890c75f9cf474c1838aa4368807a (HEAD -> master) Add explanation for musl releases
c9873b4b826f80cbc962757d51f8a93b2c649799 A few spell-checks is required in the readme file
07ebce9419f237c6383b4199842e64d0ed9c2136 Add rofi to integration with other programs  in README.md
```

```log
executing getWorkingDirectoryDiff: git diff --no-ext-diff --patch-with-raw -z --no-color HEAD -- Turtle.types.ps1xml (took 1.746s)
```