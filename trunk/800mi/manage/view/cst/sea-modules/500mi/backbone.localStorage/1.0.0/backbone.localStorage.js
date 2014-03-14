define(function(require){var e=require("underscore"),t=require("backbone"),n=require("$"),r=require("json");(function(n,r){typeof define=="function"&&define.amd?define(["underscore","backbone"],function(e,t){return r(e||n._,t||n.Backbone)}):r(e,t)})(this,function(e,t){function i(){return((1+Math.random())*65536|0).toString(16).substring(1)}function s(){return i()+i()+"-"+i()+"-"+i()+"-"+i()+"-"+i()+i()+i()}return t.LocalStorage=window.Store=function(e){this.name=e;var t=this.localStorage().getItem(this.name);this.records=t&&t.split(",")||[]},e.extend(t.LocalStorage.prototype,{save:function(){this.localStorage().setItem(this.name,this.records.join(","))},create:function(e){return e.id||(e.id=s(),e.set(e.idAttribute,e.id)),this.localStorage().setItem(this.name+"-"+e.id,r.stringify(e)),this.records.push(e.id.toString()),this.save(),this.find(e)},update:function(t){return this.localStorage().setItem(this.name+"-"+t.id,r.stringify(t)),e.include(this.records,t.id.toString())||this.records.push(t.id.toString()),this.save(),this.find(t)},find:function(e){return this.jsonData(this.localStorage().getItem(this.name+"-"+e.id))},findAll:function(){return e(this.records).chain().map(function(e){return this.jsonData(this.localStorage().getItem(this.name+"-"+e))},this).compact().value()},destroy:function(t){return t.isNew()?!1:(this.localStorage().removeItem(this.name+"-"+t.id),this.records=e.reject(this.records,function(e){return e===t.id.toString()}),this.save(),t)},localStorage:function(){return localStorage},jsonData:function(e){return e&&r.parse(e)}}),t.LocalStorage.sync=window.Store.sync=t.localSync=function(e,t,r){var i=t.localStorage||t.collection.localStorage,s,o,u=n.Deferred&&n.Deferred();try{switch(e){case"read":s=t.id!=undefined?i.find(t):i.findAll();break;case"create":s=i.create(t);break;case"update":s=i.update(t);break;case"delete":s=i.destroy(t)}}catch(a){a.code===DOMException.QUOTA_EXCEEDED_ERR&&window.localStorage.length===0?o="Private browsing is unsupported":o=a.message}return s?(t.trigger("sync",t,s,r),r&&r.success&&r.success(s),u&&u.resolve(s)):(o=o?o:"Record Not Found",r&&r.error&&r.error(o),u&&u.reject(o)),r&&r.complete&&r.complete(s),u&&u.promise()},t.ajaxSync=t.sync,t.getSyncMethod=function(e){return e.localStorage||e.collection&&e.collection.localStorage?t.localSync:t.ajaxSync},t.sync=function(e,n,r){return t.getSyncMethod(n).apply(this,[e,n,r])},t.LocalStorage})})