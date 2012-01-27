// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggleGroupOptionChildren(element) {
  if ( element.options[element.selectedIndex].className == "person-option" )
  {
    alert('Cannot collapse or expand people.')
    exit
  }
  
  selectedStyle = ( element.options[element.selectedIndex].style.textDecoration == "underline" ) ? "none" : "underline"
  expandChildren = true
  sub_depth = 0
  
  element.options[element.selectedIndex].style.textDecoration=selectedStyle
  depth = (element.options[element.selectedIndex].text.lastIndexOf("---") / 3) + 1
  
  for ( i=element.selectedIndex+1; i<element.length; i++ )
  {
    current_depth = (element.options[i].text.lastIndexOf("---") / 3) + 1
    
    if ( current_depth == depth )
    { break } // exit when we get back to the same depth as the double-clicked option
    
    if ( selectedStyle == "underline" && (current_depth > depth) ) { element.options[i].style.display = "none" }
    else {
      if ( element.options[i].className == "group-option" ) {
        if ( (sub_depth > 0) && (current_depth > sub_depth) ) { continue }
        else if ( sub_depth > 0 ) { sub_depth = 0 }
        
        element.options[i].style.display = "block"
        
        if ( element.options[i].style.textDecoration == "underline" ) {
          expandChildren = false
          sub_depth = current_depth
        }
        else { expandChildren = true } // end selector for expanding child people
      }
      else if ( element.options[i].className == "person-option" ) {
        if ( expandChildren ) { element.options[i].style.display = "block" }
      } // end group/person selector
    } // end collapse/expand selector
    
  } // end for loop
  
}
