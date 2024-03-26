import"../client.js";import"../client/default.js";import"../util/normalizeHeaderName.js";import"../util/responsePromise.js";import"../util/mixin.js";import t from"../interceptor.js";import e from"../mime.js";import"../mime/type/application/x-www-form-urlencoded.js";import"../UrlBuilder.js";import"./pathPrefix.js";import"../util/uriEncoder.js";import"../util/uriTemplate.js";import"./template.js";import"../util/find.js";import{_ as r}from"../_/8466a711.js";import"../mime/type/application/hal.js";import"../mime/type/application/json.js";import"../mime/type/multipart/form-data.js";import"../mime/type/text/plain.js";import i from"../mime/registry.js";var n={};var o,m,a,p,s,u;o=t;m=e;a=i;u=r;p={read:function(t){return t},write:function(t){return t}};s={read:function(){throw"No read method found on converter"},write:function(){throw"No write method found on converter"}};n=o({init:function(t){t.registry=t.registry||a;return t},request:function(t,e){var r,i;i=t.headers||(t.headers={});r=m.parse(i["Content-Type"]||e.mime||"text/plain");i.Accept=i.Accept||e.accept||r.raw+", application/json;q=0.8, text/plain;q=0.5, */*;q=0.2";if(!("entity"in t))return t;i["Content-Type"]=r.raw;return e.registry.lookup(r)["catch"]((function(){if(e.permissive)return p;throw"mime-unknown"})).then((function(i){var n=e.client||t.originator,o=i.write||s.write;return u(o.bind(void 0,t.entity,{client:n,request:t,mime:r,registry:e.registry}))["catch"]((function(){throw"mime-serialization"})).then((function(e){t.entity=e;return t}))}))},response:function(t,e){if(!(t.headers&&t.headers["Content-Type"]&&t.entity))return t;var r=m.parse(t.headers["Content-Type"]);return e.registry.lookup(r)["catch"]((function(){return p})).then((function(i){var n=e.client||t.request&&t.request.originator,o=i.read||s.read;return u(o.bind(void 0,t.entity,{client:n,response:t,mime:r,registry:e.registry}))["catch"]((function(e){t.error="mime-deserialization";t.cause=e;throw t})).then((function(e){t.entity=e;return t}))}))}});var c=n;export default c;
