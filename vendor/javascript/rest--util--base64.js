var e={};var r="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";function base64Encode(e){if(/([^\u0000-\u00ff])/.test(e))throw new Error("Can't base64 encode non-ASCII characters.");var a=0,t,c,s,h=[];while(a<e.length){t=e.charCodeAt(a);s=a%3;switch(s){case 0:h.push(r.charAt(t>>2));break;case 1:h.push(r.charAt((3&c)<<4|t>>4));break;case 2:h.push(r.charAt((15&c)<<2|t>>6));h.push(r.charAt(63&t));break}c=t;a+=1}if(0===s){h.push(r.charAt((3&c)<<4));h.push("==")}else if(1===s){h.push(r.charAt((15&c)<<2));h.push("=")}return h.join("")}function base64Decode(e){e=e.replace(/\s/g,"");if(!/^[a-z0-9\+\/\s]+\={0,2}$/i.test(e)||e.length%4>0)throw new Error("Not a base64-encoded string.");var a,t,c,s=0,h=[];e=e.replace(/\=/g,"");while(s<e.length){a=r.indexOf(e.charAt(s));c=s%4;switch(c){case 1:h.push(String.fromCharCode(t<<2|a>>4));break;case 2:h.push(String.fromCharCode((15&t)<<4|a>>2));break;case 3:h.push(String.fromCharCode((3&t)<<6|a));break}t=a;s+=1}return h.join("")}e={encode:base64Encode,decode:base64Decode};var a=e;const t=e.encode,c=e.decode;export default a;export{c as decode,t as encode};

