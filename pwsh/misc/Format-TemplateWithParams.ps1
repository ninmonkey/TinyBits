function FormatTemplate { 
   # Simple replace template with the pairs of hashtable key,values.
   param( 
       [string]  $template, [hashtable] $params
   )
   [string] $accum = $template

   foreach($k in $params.Keys.clone() ) {  
        $token = '{{' + $k + '}}'
        $accum = $accum -replace $token, $params[ $k ]
   }
   $accum
}

FormatTemplate -params @{ year = '2024'; ext = 'zip' } -template @"
    Date: {{year}}
    File: export-{{year}}.{{ext}}
"@

