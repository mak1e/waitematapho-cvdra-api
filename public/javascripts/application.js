// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function options_replace(select_id,options_array)
// Replace options in select box. 
{
  elem = $(select_id);
  options = elem.options;
  options.length = 1;
  for (var i=0;i<options_array.length;i++ )
    options[options.length] = new Option(options_array[i][0], options_array[i][1]);
}

function app_body_load()
// Actions to perform on load of a page 
{
  for (f=0; f < document.forms.length; f++) // for each form
    for(i=0; i < document.forms[f].length; i++) { // for each element in each form
      elem = document.forms[f][i]; 
      if ((elem.type != "hidden") && // if it's not a hidden element
          (elem.style.display != "none" ) && // if its visible
          (!elem.disabled)) { // and it's not disabled
            // elem.focus(); // set the focus to it
            Field.activate(elem); 
			//window.scrollTo(0,0);
            return 0;
        }
     }
}


//========================================
// Disable Backspace key in IE and Firefox
//========================================
// Trap Backspace(8) and Enter(13) - 
// Except bksp on text/textareas, enter on textarea/submit

document.onkeypress = function(event) {
  if (typeof window.event != 'undefined') { // ie
    event = window.event;
    event.target = event.srcElement; // make ie confirm to standards !!
  }
  var kc=event.keyCode;
  var tt=event.target.type;
  if ((kc == 13) && (event.target.getAttribute('enter_ok') == 'true')) {
  	return true; // ok
  }
  
  // alert('kc='+kc+", tt="+tt);
  if ((kc != 8 && kc != 13) || ((tt == 'text' || tt == 'password') && kc != 13) ||
	  (tt == 'textarea') || (tt == 'submit' && kc == 13))
	return true;
  alert('Bksp/Enter is not allowed here'); 
  return false;
}

if (typeof window.event != 'undefined') // ie
  document.onkeydown = document.onkeypress; // Trap bksp in ie. !! Note: does not trap enter, but onkeypress does !!


