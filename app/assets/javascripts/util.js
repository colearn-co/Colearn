
(function(d){
 var
 ce=function(e,n){var a=document.createEvent("CustomEvent");a.initCustomEvent(n,true,true,e.target);e.target.dispatchEvent(a);a=null;return false},
 nm=true,sp={x:0,y:0},ep={x:0,y:0},
 touch={
  touchstart:function(e){sp={x:e.touches[0].pageX,y:e.touches[0].pageY}},
  touchmove:function(e){nm=false;ep={x:e.touches[0].pageX,y:e.touches[0].pageY}},
  touchend:function(e){if(nm){ce(e,'fc')}else{var x=ep.x-sp.x,xr=Math.abs(x),y=ep.y-sp.y,yr=Math.abs(y);if(Math.max(xr,yr)>20){ce(e,(xr>yr?(x<0?'swl':'swr'):(y<0?'swu':'swd')))}};nm=true},
  touchcancel:function(e){nm=false}
 };
 for(var a in touch){d.addEventListener(a,touch[a],false);}
})(document);


var util = {};
util.escapeHtml = function(unsafe) {
    return unsafe
         .replace(/&/g, "&amp;")
         .replace(/</g, "&lt;")
         .replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;")
         .replace(/'/g, "&#039;");
}
util.showFullPageOverlay =  function() {
	$("#overlay-full-page-div").addClass("overlay-full-page");
}
util.hideFullPageOverlay = function() {
	$("#overlay-full-page-div").removeClass("overlay-full-page");
}

util.emailErrors = function (message) {
    var req = new XMLHttpRequest();
    var params = "message=" + encodeURIComponent(message);
    req.open("POST", "/log_js_error", true);
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.send(params);
}

util.generateRandomString = function stringGen(len) { //TODO: this is not secure random so probabilities of collision is not gaunted.
    var text = [];

    var charset = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    for( var i=0; i < len; i++ )
        text.push(charset.charAt(Math.floor(Math.random() * charset.length)));

    return text.join("");
}



