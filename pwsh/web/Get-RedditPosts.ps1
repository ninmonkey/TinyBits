#requires -Modules pansies
#requires -PSEdition Core

# simple lazy cache ( when dotsourced )
$resp ??= Invoke-RestMethod -Uri ( [uri] $url = 'https://www.reddit.com/r/PowerBI/rising/.json' ) -HttpVersion 3
$json = $resp.data.children.data

function __renderDisplay {
    param( [object] $Obj )
    $str_flair = $Obj.link_flair_text |  New-Text -bg $Obj.link_flair_background_color
    $str_score = @(
        '+{0} [ {1} Comments ]' -f @(
            $Obj.score
            $Obj.num_comments
        )
    ) -join ''

    "${str_flair} ${str_score}"
}
function __renderDisplay2 {
    param( [object] $Obj )
    $str_flair = $Obj.link_flair_text |  New-Text -bg $Obj.link_flair_background_color
    $str_score = @(
        '+{0} [ {1} Comments ]' -f @(
            $Obj.score
            $Obj.num_comments
        )
    ) -join ''

    $str_author = $Obj.author
    $str_title = $Obj.title
    @(
        "${str_flair} ${str_author}"
        "    ${str_title}"
        "    ${str_score}"
    ) | Join-String -sep "`n"
}

$ParsedJsonExtra = $json | %{
    $cur = $_
    # not optimal, but good enough for here.
    $cur | Select-Object -ea ignore -p 'Display', Subreddit, author, author_flair_richtext, author_fullname, score, num_comments, title, url, permalink, is_*, selftext, selftext_html, view_count, discussion_type, name, category,created_utc, link_*, pinned, subreddit_*, thumbnail*
        | Add-Member -Force -PassThru -NotePropertyMembers @{
            Display  = __renderDisplay $_
            Display2 = __renderDisplay2 $_
        }


    }

$ParsedJsonExtra | ft Display, author, title, selftext -GroupBy subreddit
