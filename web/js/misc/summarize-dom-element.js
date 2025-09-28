
export function SummarizeSvgDocument ( targetRoots ) {
    /** @description Focus on specific attributes, reducing information
     * @example res = window.fn.debug_SummarizeDom( $$('svg') ); console.table( res ) ;
     * */    const list = Array.isArray( targetRoots ) ? targetRoots : [ targetRoots ]
    const res = list.flatMap( ( m ) => SummarizeSvgDoc_parseOne( m ) )
    let orderId = 0
    res.forEach( ( r, i ) => r.orderId = orderId++ )
    return res
}

//  * @example console.table( window.fn.debug_SummarizeDom( $$('svg')[0] ) )
// targets = $$('svg')
// resOne = window.fn.debug_SummarizeDom( targets[0] )
// res = targets.flatMap( (m) => window.fn.debug_SummarizeDom( m ) )

function SummarizeSvgDoc_parseOne ( docRoot, namespace = null ) {
    /**
     * @description Summarize the elements in a document or sub-tree, highlight more important parts
     */
    const records = Array.from(
        docRoot.querySelectorAll( '*' )
    )
        .map( ( elem ) => {
            const info = {
                name: elem.tagName,
                childCount: elem.childElementCount,
                attrNames: elem.getAttributeNames().toSorted(),
                attrNames_str: elem.getAttributeNames().toSorted().join( ', ' ),

                attrAbbr: [ `id: "${ elem.getAttributeNS( namespace, 'id' )
                    }" class: "${ elem.getAttributeNS( namespace, 'class' )
                    }"`,
                ].join( '' ),

                childNamesAbbr: Array.from( elem.parentNode.childNodes ).
                    flatMap( (m) => m.tagName ).join( ', '),

                depth: 0
            }
            return info

        } )
    return records
}