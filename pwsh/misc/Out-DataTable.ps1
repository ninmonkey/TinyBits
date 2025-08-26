<#
.SYNOPSIS
Converts an object's properties to a [Data.DataTable]
.OUTPUTS
   Data.DataTable
.notes
I started with this script and cleaned it up some: https://github.com/o-o00o-o/PSEasy.Utility/blob/main/PSEasy.Utility/Data/DataSet/Out-DataTable.ps1#L6
#>
function Out-DataTable
{
    [CmdletBinding()]
    param(
        [Parameter( Position=0, Mandatory, ValueFromPipeline)]
        [Object[]] $InputObject
    )

    Begin {
        # $TableName = 'Dt' $namespace = 'namespace'

        <# ctor => (), (name), (name,namespace) #>
        $dTable = [System.Data.DataTable]::new()

        $First = $true
        # [System.Data.DataTable]::new(
        #     <# tableName: #> $tableName,
        #     <# tableNamespace: #> $tableNamespace)
    }
    Process {
        try {
            foreach ( $object in $InputObject ) {
                $dRow = $dTable.NewRow()
                foreach( $property in $object.PsObject.Properties ) {
                    if ($first) {
                        <# ctor =>  string columnName,  Type dataType,
                                    string expr,        MappingType type       #>
                        $dCol =  [Data.DataColumn]::new()
                        $dCol.ColumnName = $property.Name.ToString().Trim()
                        if ($property.value) {
                            if ($property.value -isnot [System.DBNull]) {
                                # $dCol.DataType = [System.Type]::GetType("$(Get-Type $property.TypeNameOfValue)")
                                $dCol.DataType = ($property.value)?.GetType()
                             }
                        }
                        $dTable.Columns.Add($dCol)
                    }
                    if ( $property.Gettype().IsArray ) {
                        $dRow.Item( $property.Name.Trim() ) = $property.value
                            | ConvertTo-XML -AS String -NoTypeInformation -Depth 1
                    } else {
                        $dRow.Item( $property.Name.Trim() ) = $property.value
                    }
                }
                $dTable.Rows.Add($dRow)
                $First = $false
            }
        }
        catch {
            throw
        }
    }

    End {
        Write-Output @(, ($dTable) )
    }

} #Out-DataTable
