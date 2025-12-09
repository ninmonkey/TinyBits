
function TinyBits.Fzf.Select {
    <#
    .example
    > Get-Process | % Name | Sort-Object -Unique | TinyBits.Fzf.Select
    #>
    $choices = @( $Input )
    $choices | fzf --multi --tac --gap=1 --gap-line='___' --cycle --layout=reverse-list
}

<#
.notes

args:
    --list-border=[rounded|sharp|bold|block|thinblock|double|horizontal|vertical|top|bottom|left|right|none] (default: rounded)

    HEADER
    --header=STR             String to print as header
    --header-lines=N         The first N lines of the input are treated as header
    --header-first           Print header before the prompt line
    --header-border[=STYLE]  Draw border around the header section
                                [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|top|bottom|left|right|line|none] (default: rounded)
    --header-lines-border[=STYLE]
                                Display header from --header-lines with a separate border.
                                Pass 'none' to still separate it but without a border.
    --header-label=LABEL     Label to print on the header border
    --header-label-pos=COL   Position of the header label
                                [POSITIVE_INTEGER: columns from left|
                                NEGATIVE_INTEGER: columns from right][:bottom]
                                (default: 0 or center)

    FOOTER
    --footer=STR             String to print as footer
    --footer-border[=STYLE]  Draw border around the footer section
                                [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|top|bottom|left|right|line|none] (default: line)
    --footer-label=LABEL     Label to print on the footer border
    --footer-label-pos=COL   Position of the footer label
                                [POSITIVE_INTEGER: columns from left|
                                NEGATIVE_INTEGER: columns from right][:bottom]
                                (default: 0 or center)

    $Choices | fzf --multi --tac --gap=3 --gap-line='___'

DISPLAY MODE
--height=[~]HEIGHT[%]    Display fzf window below the cursor with the given
                            height instead of using fullscreen.
                            A negative value is calculated as the terminal height
                            minus the given value.
                            If prefixed with '~', fzf will determine the height
                            according to the input size.
--min-height=HEIGHT[+]   Minimum height when --height is given as a percentage.
                            Add '+' to automatically increase the value
                            according to the other layout options (default: 10+).
--tmux[=OPTS]            Start fzf in a tmux popup (requires tmux 3.3+)
                            [center|top|bottom|left|right][,SIZE[%]][,SIZE[%]]
                            [,border-native] (default: center,50%)

LAYOUT
--layout=LAYOUT          Choose layout: [default|reverse|reverse-list]
--margin=MARGIN          Screen margin (TRBL | TB,RL | T,RL,B | T,R,B,L)
--padding=PADDING        Padding inside border (TRBL | TB,RL | T,RL,B | T,R,B,L)
--border[=STYLE]         Draw border around the finder
                            [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|
                            top|bottom|left|right|line|none] (default: rounded)
--border-label=LABEL     Label to print on the border
--border-label-pos=COL   Position of the border label
                            [POSITIVE_INTEGER: columns from left|
                            NEGATIVE_INTEGER: columns from right][:bottom]
                            (default: 0 or center)

LIST SECTION
-m, --multi[=MAX]        Enable multi-select with tab/shift-tab
--highlight-line         Highlight the whole current line
--cycle                  Enable cyclic scroll
--wrap                   Enable line wrap
--wrap-sign=STR          Indicator for wrapped lines
--no-multi-line          Disable multi-line display of items when using --read0
--track                  Track the current selection when the result is updated
--tac                    Reverse the order of the input
--gap[=N]                Render empty lines between each item
--gap-line[=STR]         Draw horizontal line on each gap using the string
                            (default: '┈' or '-')
--keep-right             Keep the right end of the line visible on overflow
--scroll-off=LINES       Number of screen lines to keep above or below when
                            scrolling to the top or to the bottom (default: 0)

                            * See man page for more information: fzf --man

Usage: fzf [options]

SEARCH
-e, --exact              Enable exact-match
+x, --no-extended        Disable extended-search mode
-i, --ignore-case        Case-insensitive match
+i, --no-ignore-case     Case-sensitive match
    --smart-case         Smart-case match (default)
--scheme=SCHEME          Scoring scheme [default|path|history]
-n, --nth=N[,..]         Comma-separated list of field index expressions
                            for limiting search scope. Each can be a non-zero
                            integer or a range expression ([BEGIN]..[END]).
--with-nth=N[,..]        Transform the presentation of each line using
                            field index expressions
--accept-nth=N[,..]      Define which fields to print on accept
-d, --delimiter=STR      Field delimiter regex (default: AWK-style)
+s, --no-sort            Do not sort the result
--literal                Do not normalize latin script letters
--tail=NUM               Maximum number of items to keep in memory
--disabled               Do not perform search
--tiebreak=CRI[,..]      Comma-separated list of sort criteria to apply
                            when the scores are tied
                            [length|chunk|pathname|begin|end|index] (default: length)

INPUT/OUTPUT
--read0                  Read input delimited by ASCII NUL characters
--print0                 Print output delimited by ASCII NUL characters
--ansi                   Enable processing of ANSI color codes
--sync                   Synchronous search for multi-staged filtering

GLOBAL STYLE
--style=PRESET           Apply a style preset [default|minimal|full[:BORDER_STYLE]
--color=COLSPEC          Base scheme (dark|light|16|bw) and/or custom colors
--no-color               Disable colors
--no-bold                Do not use bold text

DISPLAY MODE
--height=[~]HEIGHT[%]    Display fzf window below the cursor with the given
                            height instead of using fullscreen.
                            A negative value is calculated as the terminal height
                            minus the given value.
                            If prefixed with '~', fzf will determine the height
                            according to the input size.
--min-height=HEIGHT[+]   Minimum height when --height is given as a percentage.
                            Add '+' to automatically increase the value
                            according to the other layout options (default: 10+).
--tmux[=OPTS]            Start fzf in a tmux popup (requires tmux 3.3+)
                            [center|top|bottom|left|right][,SIZE[%]][,SIZE[%]]
                            [,border-native] (default: center,50%)

LAYOUT
--layout=LAYOUT          Choose layout: [default|reverse|reverse-list]
--margin=MARGIN          Screen margin (TRBL | TB,RL | T,RL,B | T,R,B,L)
--padding=PADDING        Padding inside border (TRBL | TB,RL | T,RL,B | T,R,B,L)
--border[=STYLE]         Draw border around the finder
                            [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|
                            top|bottom|left|right|line|none] (default: rounded)
--border-label=LABEL     Label to print on the border
--border-label-pos=COL   Position of the border label
                            [POSITIVE_INTEGER: columns from left|
                            NEGATIVE_INTEGER: columns from right][:bottom]
                            (default: 0 or center)

LIST SECTION
-m, --multi[=MAX]        Enable multi-select with tab/shift-tab
--highlight-line         Highlight the whole current line
--cycle                  Enable cyclic scroll
--wrap                   Enable line wrap
--wrap-sign=STR          Indicator for wrapped lines
--no-multi-line          Disable multi-line display of items when using --read0
--track                  Track the current selection when the result is updated
--tac                    Reverse the order of the input
--gap[=N]                Render empty lines between each item
--gap-line[=STR]         Draw horizontal line on each gap using the string
                            (default: '┈' or '-')
--keep-right             Keep the right end of the line visible on overflow
--scroll-off=LINES       Number of screen lines to keep above or below when
                            scrolling to the top or to the bottom (default: 0)
--no-hscroll             Disable horizontal scroll
--hscroll-off=COLS       Number of screen columns to keep to the right of the
                            highlighted substring (default: 10)
--jump-labels=CHARS      Label characters for jump mode
--pointer=STR            Pointer to the current line (default: '▌' or '>')
--marker=STR             Multi-select marker (default: '┃' or '>')
--marker-multi-line=STR  Multi-select marker for multi-line entries;
                            3 elements for top, middle, and bottom (default: '╻┃╹')
--ellipsis=STR           Ellipsis to show when line is truncated (default: '··')
--tabstop=SPACES         Number of spaces for a tab character (default: 8)
--scrollbar[=C1[C2]]     Scrollbar character(s)
                            (each for list section and preview window)
--no-scrollbar           Hide scrollbar
--list-border[=STYLE]    Draw border around the list section
                            [rounded|sharp|bold|block|thinblock|double|horizontal|vertical|
                            top|bottom|left|right|none] (default: rounded)
--list-label=LABEL       Label to print on the list border
--list-label-pos=COL     Position of the list label
                            [POSITIVE_INTEGER: columns from left|
#>
