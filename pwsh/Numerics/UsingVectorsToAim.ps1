using namespace System.Numerics
using namespace System.Collections.Generic

<#
.notes

See:
- namespace [System.Numerics](https://learn.microsoft.com/en-us/dotnet/api/system.numerics?view=net-10.0)

#>

$player    = [Vector2]::new( 10, 30 )
$monster   = [Vector2]::new( 100, 100 )

$toMonster = [Vector2]::Subtract( $monster, $player )
$toMonster.Length() -eq [vector2]::Distance( $player, $monster ) # true


# Nonsense examples using different overloads

$point1 = [Vector3]::new( 3 )
$point2 = [Vector3]::new( 20, 40 )
$point3 = [Vector3]::New(
    <# Vector2 #> [Vector2]::UnitX, 4.5 )

[Plane]::CreateFromVertices(
    <# Vector3 #> $point1,
    <# Vector3 #> $point2,
    <# Vector3 #> $point3 )


$d1 = [vector[double]]::new( 3.4 )

# ...


$rad1 = [vector]::DegreesToRadians( [double] 90 )
$rad2 = [vector]::DegreesToRadians( [double] 180 )
[Vector]::Cos( $rad1 )
[Vector]::Cos( $rad2 )
[Vector]::Cos( ([vector]::DegreesToRadians( [double] 90 ) ) )
