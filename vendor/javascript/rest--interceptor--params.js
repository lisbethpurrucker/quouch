import"../client.js";import"../client/default.js";import"../util/normalizeHeaderName.js";import"../util/responsePromise.js";import"../util/mixin.js";import r from"../interceptor.js";import"../mime/type/application/x-www-form-urlencoded.js";import t from"../UrlBuilder.js";var e={};var i,a;i=r;a=t;e=i({init:function(r){r.params=r.params||{};return r},request:function(r,t){var e,i;e=r.path||"";i=r.params||{};r.path=new a(e,t.params).append("",i).build();delete r.params;return r}});var p=e;export default p;
