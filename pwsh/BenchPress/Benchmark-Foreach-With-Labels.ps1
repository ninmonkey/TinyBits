#requires -Modules 'Benchpress'


( $res = Measure-Benchmark -Technique @{
    '| %' =
        { 1..100000 | % { $_ } }

    '@( range).forEach' =
        { @(1..100000).foreach{ $_ } }

    'for( range )' =
        { for ($i = 1; $i -le 100000; $i++) { $i } }

    'range | & { process }' =
         { 1..100000 | & { process { $_ } } }

    'foreach( range )' =
         { foreach ($i in 1..100000) { $_ }}

    } -GroupName "testy" -RepeatCount 5 -AsJob -Detailed)

$usingColor = $false
$summary = $res | Receive-Job -AutoRemoveJob -Wait
$Summary | %{
    $SourceCode = if( $usingColor ) {
        $_.Details.Command | bat -l ps1 -f
    } else {
        $_.Details.Command
    }
    $_ | Add-Member -NotePropertyMembers @{
        TotalMs = '{0:n2} Ms' -f $_.Time.TotalMilliseconds
        Source = $SourceCode
    } -Force -PassThru

}
| Format-Table -AutoSize

$summary | Ft Technique, Time, RelativeSpeed, Throughput, TotalMs, Source
