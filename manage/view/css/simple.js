// JavaScript Document
function onFold(e,t){	
	var pn=e.parentNode;
	pn.ori=pn.innerHTML;		
	pn.innerHTML="";
	var unfold = document.createElement("a");
	unfold.href="javascript:;";
	unfold.className="unfold";
	unfold.innerHTML="展开"+t;
	unfold.onclick = function(){
		pn.innerHTML = pn.ori;
	}
	pn.appendChild(unfold);
}

//function onClose(e){ var el=e.parentNode.parentNode.parentNode.parentNode.parentNode.parentNode.style.visibility="hidden"; }
//function onOpen(t){ document.getElementById(t).style.visibility="visible"; }