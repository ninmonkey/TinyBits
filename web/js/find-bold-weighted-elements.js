
/*
about: Lots of bold elements are not using <b> elements
    So, lets search the computed font-weight property to find them
*/
function calcStyle ( element, cssAttribute = 'font-weight' ) {
    return window.getComputedStyle( element )[ cssAttribute ]
}

// brute force
const found = Array.from( document.querySelectorAll( '*' ) )

const grps = Object.groupBy( found, ( e ) => calcStyle( e, 'font-weight' ) )
Object.keys( grps ) // is: Array(4) [ "400", "500", "600", "700" ]

const only_bold = found.filter( ( e ) => calcStyle( e, 'font-weight' ) > 400 )
// only_bold.map( ( e ) => calcStyle( e, 'font-weight' ) )

// grouped elements by weights
const bold_byGroup = Object.groupBy( only_bold, ( e ) => calcStyle( e, 'font-weight' ) )

bold_byGroup[ '700' ]