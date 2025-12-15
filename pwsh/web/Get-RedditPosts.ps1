#requires -Modules pansies
#requires -PSEdition Core

# If you dotsource the script, '??=' will cache the response
$resp ??= Invoke-RestMethod -Uri ( [uri] $url = 'https://www.reddit.com/r/PowerBI/rising/.json' ) -HttpVersion 3

function _renderDisplay {
    # Ansi color as a single line
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
function _renderDisplay2 {
    # Ansi color as multiple lines
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

filter Format-RedditResponse {
    # drops a bunch of properties, and adds some for rendering
    $cur = $_
    # not optimal, but good enough for here.
    $cur
        | Select-Object -ea ignore -p Display, Subreddit, author, author_flair_richtext, author_fullname,
            score, num_comments, title, url, permalink, is_*, selftext, selftext_html, view_count, discussion_type,
                name, category,created_utc, link_*, pinned, subreddit_*, thumbnail*
        | Add-Member -Force -PassThru -NotePropertyMembers @{
            Display    = _renderDisplay $_
            Display2   = _renderDisplay2 $_
            DisplayUrl = Pansies\New-Hyperlink -Uri $_.url -obj $_.title
        }

}

$json   = $resp.data.children.data
$parsed = $json | Format-RedditResponse

$parsed | Join-String Display2 "`n`n"
$parsed | Format-Table Display, author, title -GroupBy Subreddit
