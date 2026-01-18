#requires -Modules Pansies

function IdName { 
   # create a new Id with color
   $grads = Get-Gradient Tomato blue -Width 7
   if( $script:id -gt $grads.count ) { $script:id = 0 }
   $i = ( $script:id++ )
   $i | New-Text -bg $grads[ $i ]
}
$id = 0  

function BatHost { 
   # do something. visualizes steps in the pipeline
   begin { 
     $myId = IdName
     "=> ${MyId} Begin()" | write-host }
   process { 
      '    item: 🦇 is {0} from {1}' -f ($_, $MyId) | write-host 
      
      # output the value, I didn't do any calculation
      $_
   }
   end { "=> ${myId} End()"  | write-host }
}
'a'..'c' |  BatHost | BatHost | BatHost | BatHost
