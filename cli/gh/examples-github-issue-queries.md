---
title: "Github Issue Queries Reference"
description: "Queries used by the site, or through 'gh' cli"
---

- [Docs](#docs)
- [Misc](#misc)
  - [Open issue with no Labels](#open-issue-with-no-labels)
  - [Named `Text` without the label `Text`](#named-text-without-the-label-text)
  - [Named `string` or `text` and without the label `Text`](#named-string-or-text-and-without-the-label-text)
  - [Fields](#fields)


# Docs

- [docs.github.com](https://docs.github.com)
  - [filtering and searching issues and pull requests](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/filtering-and-searching-issues-and-pull-requests)
  - [filtering projects and issues](https://docs.github.com/en/issues/planning-and-tracking-with-projects/customizing-views-in-your-project/filtering-projects)
  - [understanding fields](https://docs.github.com/en/issues/planning-and-tracking-with-projects/understanding-fields)
- GraphQL / `gh` cli
  - [Understanding the Search Syntax](https://docs.github.com/en/search-github/getting-started-with-searching-on-github/understanding-the-search-syntax)
# Misc

## Open issue with no Labels

```ts
is:issue state:open no:label
is:issue is:open no:label
```

## Named `Text` without the label `Text`

```ts
is:issue state:open text -label:Text
```
[Named `Text` without the label `Text`](https://github.com/ninmonkey/Mintils.ps1/issues?q=is%3Aissue%20state%3Aopen%20text%20-label%3AText)

## Named `string` or `text` and without the label `Text`

```ts
is:issue state:open ( string OR text ) -label:Text
```
[`is:issue state:open ( string OR text ) -label:Text`](https://github.com/ninmonkey/Mintils.ps1/issues?q=is%3Aissue%20state%3Aopen%20(%20string%20OR%20text%20)%20-label%3AText)

## Fields 

- `no:FIELD` - Issues with no values in FIELD
- `-no:FIELD` - Issues a value in FIELD