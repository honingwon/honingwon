function GameID_HLQS()
{
	return 1; //幻龙骑士
}
function GameID_CYFX()
{
	return 32; //穿越防线
}

function Trim(str) {
    return str.replace(/(^\s*)|(\s*$)/g, "");
}

//取得字符串长度(全角字符长度为2)
function strlen(str) {
    var i;
    var len;
    len = 0;
    for (i = 0; i < str.length; i++) {
        if (str.charCodeAt(i) > 255)
            len += 2;
        else
            len++;
    }
    return len;
}

function parseObj( strData ){
	return (new Function( "return " + strData ))();
}

function getDate() {
    var d, s, t;
    d = new Date();
    s = d.getFullYear().toString(10) + "-";
    t = d.getMonth() + 1;
    s += (t > 9 ? "" : "0") + t + "-";
    t = d.getDate();
    s += (t > 9 ? "" : "0") + t + " ";
    t = d.getHours();
    s += (t > 9 ? "" : "0") + t;
    t = d.getMinutes();
    s += (t > 9 ? "" : "0") + t;
    t = d.getSeconds();
    s += (t > 9 ? "" : "0") + t;
    return s;
}
function getDateMinuteDay() {
    var d, s, t;
    d = new Date();
    s = d.getFullYear().toString(10) + "-";
    t = d.getMonth() + 1;
    s += (t > 9 ? "" : "0") + t + "-";
    t = d.getDate();
    s += (t > 9 ? "" : "0") + t + " ";
    s += "00:00"
    return s;
}

function getDateMinute() {
    var d, s, t;
    d = new Date();
    s = d.getFullYear().toString(10) + "-";
    t = d.getMonth() + 1;
    s += (t > 9 ? "" : "0") + t + "-";
    t = d.getDate();
    s += (t > 9 ? "" : "0") + t + " ";
    t = d.getHours();
    s += (t > 9 ? "" : "0") + t;
    t = d.getMinutes();
    s += ":" + (t > 9 ? "" : "0") + t;
    return s;
}


function getMDateMinuteDay() {
    var d, s, t;
    d = new Date(new Date().getTime()+86400000-(new
    		Date().getHours()*60*60+new Date().getMinutes()*60+new
    		Date().getSeconds())*1000);
    s = d.getFullYear().toString(10) + "-";
    t = d.getMonth() + 1;
    s += (t > 9 ? "" : "0") + t + "-";
    t = d.getDate();
    s += (t > 9 ? "" : "0") + t + " ";
    t = d.getHours();
    s += (t > 9 ? "" : "0") + t;
    t = d.getMinutes();
    s += ":" + (t > 9 ? "" : "0") + t;
    return s;
}


/*
function GetDateStr(AddDayCount){ 
	var dd = new Date(); 
	dd.setDate(dd.getDate()+AddDayCount);//获取AddDayCount天后的日期 
	var y = dd.getYear(); 
	var m = dd.getMonth()+1;//获取当前月份的日期 
	var d = dd.getDate(); 
	return y+"-"+m+"-"+d; 
}*/


function GetDateStr() {
    var d, s, t;
    d = new Date();
    s = d.getFullYear().toString(10) + "-";
    t = d.getMonth() + 1;
    s += (t > 9 ? "" : "0") + t + "-";
    t = d.getDate();
    s += (t > 9 ? "" : "0") + t + " ";
    s += "23:59"
    return s;
}


//网址检验
function isUrl (URL) {
    return /^http[s]{0,1}:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^\"\"])*$/gi.test(URL);
}

//邮件地址检验
function isEmail(emailvalue) {
    return /^([a-zA-Z0-9])+@([a-zA-Z0-9])+\.([a-zA-Z0-9])+/gi.test(emailvalue)
}
    
//固定电话检验
function  isTelePhone(num) {
    return /^(0\d{2,3}-)\d{7,8}$/gi.test(num);
}

//手机号码检验
function  isMobilePhone(num) {
    return /^(1[358][0-9]{9})$/gi.test(num);
}

//QQ号码检验
function  isQQNum(num) {
    return /^[1-9]\d{3,8}$/gi.test(num);
}

function setOnbur(id, message) {
    if ($("#" + id).parent().find("#check" + id).size() == 0)
        $("#" + id).after("</br><span id=\"check" + id + "\"  class=\"tc_rad\"/>");
    $("#check" + id).html(message);
}

function setOnburPline(id, message) {
    if ($("#" + id).parent().find("#check" + id).size() == 0)
        $("#" + id).after("<span id=\"check" + id + "\"  class=\"tc_rad\"/>");
    $("#check" + id).html(message);
}

//检测是否为整数
function ck_int(s){
	var re = /^[0-9]*$/ ;
	return re.test(s)
}

function GetDateDiff(startTime, endTime, diffType) { 
	 //将xxxx-xx-xx的时间格式，转换为 xxxx/xx/xx的格式 
	 startTime = startTime.replace(/-/g, "/"); 
	 endTime = endTime.replace(/-/g, "/"); 
	 //将计算间隔类性字符转换为小写 
	 diffType = diffType.toLowerCase(); 
	 var sTime = new Date(startTime); //开始时间 
	 var eTime = new Date(endTime); //结束时间 
	 //作为除数的数字 
	 var divNum = 1; 
	 switch (diffType) { 
	 case "second": 
	 divNum = 1000; 
	 break; 
	 case "minute": 
	 divNum = 1000 * 60; 
	 break; 
	 case "hour": 
	 divNum = 1000 * 3600; 
	 break; 
	 case "day": 
	 divNum = 1000 * 3600 * 24; 
	 break; 
	 default: 
	 break; 
	 } 
	 return parseInt((eTime.getTime() - sTime.getTime()) / parseInt(divNum)); 
	 }


function showCommonMsg(falg,msg,obj){
	if(!falg){
		document.getElementById(obj).innerHTML =msg;
		document.getElementById(obj).style.visibility="visible";
	}
	else
		document.getElementById(obj).style.visibility="hidden";
}