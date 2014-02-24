/*
BMClass 创建
*/
var BMClass = {
    Version: '1.0.1',
    create: function() {
        return function() { this.initialize.apply(this, arguments);}
    }
};




