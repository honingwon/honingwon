var _URL = "../model/BaseData/AccountManageMethod.php";
var _msgURL = "链接出错";
var _pageAccountID = "AccountID";
var _pageNickName = "NickName";
var _pageSelectAccountType = "SelectAccountType";
var _pageSelectAccountLevel = "SelectAccountLevel";
var _pagePhone = "Phone";
var _pageEmail = "Email";
var _pageQQ = "QQ";
var _pageAddress = "Address";
var _pageARemark = "ARemark";
var _Currenpage = 1;
var _CurrentPageLine = 20;
var _AccountID = null;

$(document).ready(function() {
	LoadData()
	$("#btnAddAccount").bind("click",function(){ 
		_AccountID = null;
		$('#'+_pageAccountID).attr('disabled', 0);
		$("#accountEditTitle").html("添加新帐号");
		$("#accountEdit").show();
		});
	pageLoading();
	$("#btnAccountSave").bind("click",btnAccountSaveClickHandler);
	$("#btnResetPWD").bind("click",btnResetPWDClickHandler);
	$("#btnSearch").bind("click",btnAccountSearchClickHandler);
	$("#BtncloseAccountEdit").bind("click",function(){_AccountID = null;initEditData(null);$("#accountEdit").hide();});
	$("#BtnclosePerServer").bind("click",function(){$("#perServer").hide();})
	$("#BtnclosePerAccount").bind("click",function(){$("#perAccount").hide();})
	$("#BtnclosePerGroup").bind("click",function(){$("#perGroup").hide();})
});

function LoadData()
{
	setOnbur("txtSearchName","");
	var type = $("#selSearchType").val();
	var txt =  $("#txtSearchName").val();
	var dataStr = {"method": "List","account":txt,"pagesize":_CurrentPageLine,"curpage":_Currenpage,"type":type };
	$.ajax({type: "post",url: _URL,　dataType: "json",data: dataStr,
		success: function(result) {
				FormatData(result);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function FormatData(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body").html(TableBodyRow(1,null,"系统忙，请稍后"));
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	var str = "error" +　DataList.Tag + DataList.Message;
    	$("#List_Body").html(TableBodyRow(1,null,"暂未有帐号信息"));//
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	html += TableBodyRow(num,row,"");
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange", "divPagination", 1)
    $("#List_Body").html(html);
}

function PageChange(num)
{
	_Currenpage = num
	LoadData();
}

function TableBodyRow(rowNum,data,msg){
	if(data == null) return "<tr><td colspan='4' class='tc_rad'>"+msg+"</td></tr>";
	var className = rowNum % 2 == 0 ? "even":"";
	var ophtm1 = 
				'[<a href="javascript:void(0);" onclick="javascript:DoModuleRights(\'' + data.acct_id + '\',\'' + data.acct_name + '\')">设置功能权限</a>]'+
				'[<a href="javascript:void(0);" onclick="javascript:DoGroup(\'' + data.acct_id + '\',\'' + data.acct_name + '\')">设置所在分组</a>]';
	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:Edit(\'' + data.acct_id + '\')">修改信息</a>]'+
				'[<a href="javascript:void(0);" onclick="javascript:Del(\'' + data.acct_id + '\')">删除</a>]';
	var html = "<tr class='"+className+"'><td>"+data.account+"</td><td>"+data.acct_name+"</td><td>"+GetAccountTypeName(data.acct_type)+"</td><td class='tc_gray'>"+ophtm1+"</td><td class='operate'>"+ophtm+"</td></tr>";
   return  html;
}

function btnAccountSaveClickHandler()
{
	var fAccount = checkAccount();
	var fName = checkName();
	var fType = checkAccountType();
	var fLevel = checkAccountLevel();
	if(fAccount && fName && fType && fLevel && checkRemark()){
		var AccountID = $("#"+_pageAccountID).val(); 
		var NickName = $("#"+_pageNickName).val();
		var AccountType = document.getElementById(_pageSelectAccountType).value;
		var AccountLevel = document.getElementById(_pageSelectAccountLevel).value;
		//var Phone = $("#"+_pagePhone).val();
		//var Email = $("#"+_pageEmail).val();
		//var QQ = $("#"+_pageQQ).val();
		//var Address = $("#"+_pageAddress).val();
		var ARemark = $("#"+_pageARemark).val();
		if(_AccountID == null){
			var dataStr = {"method": "Add","account":AccountID,"name":NickName,"level":AccountLevel,"type":AccountType,"dec":ARemark};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
				success: function(result) {
					if(result.Success){
						alert("新增成功");
						initEditData(null);
						$("#accountEdit").hide();
						_Currenpage = 1;
						LoadData();
					}
					else
						alert("新增失败："+result.Message);
				},
				error: function(e) {alert(e);}
			});
		}
		else{
			var dataStr1 = {"method": "edit","name":NickName,"level":AccountLevel,"type":AccountType,"dec":ARemark,"ID":_AccountID};
			$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr1,
				success: function(result) {
					if(result.Success){
						alert("修改成功");
						_Currenpage = 1;
						LoadData();
					}
					else
						alert("修改失败："+result.Message);
				},
				error: function(e) {alert(_msgURL);}
			});
		}
	}
}

function btnResetPWDClickHandler()
{
	if(_AccountID == null) {
		alert("请刷新后再试");return;
	}
	var dataStr = {"method": "reset","ID":_AccountID};
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
			if(result.Success){
				alert("初始化成功！");
//				initEditData(null);
//				$("#accountEdit").hide();
//				LoadData();
			}
			else
				alert("初始化失败："+result.Message);
		},
		error: function(e) {alert(_msgURL);}
	});
}

function btnAccountSearchClickHandler()
{
	var type = $("#selSearchType").val();
	if(type > 0) {
		var str = type == 1 ? "账号" : "姓名";
		var txt =  $("#txtSearchName").val();
		if (Trim(txt) == "") {
			setOnbur("txtSearchName",str+"不能为空！");
			return ;
		}
		if (strlen(Trim(txt)) < 1 || strlen(Trim(txt)) > 50) {
			setOnbur("txtSearchName",str+"长度要在50字符之内！");
			return;
		}
	}
	else
		$("#txtSearchName").val("");
	_Currenpage = 1;
	LoadData();
}

function Edit(accountID)
{
	var dataStr = {"method": "oneFo","ID":accountID};
	$.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
		success: function(result) {
		   if(result.Success){
			   $('#'+_pageAccountID).attr('disabled', 1);
				_AccountID = accountID;
				initEditData(result.DataList[0]);
				$("#accountEditTitle").html("修改帐号信息");
				$("#accountEdit").show(); 
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function Del(accountID)
{
	if (!confirm("您确定删除?"))
        return;
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "del","ID":accountID},
		success: function(result) {
		   if(result.Success){
			    alert("删除成功");
				initEditData(null);
				$("#accountEdit").hide();
				_Currenpage = 1;
				LoadData();
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function GetAccountTypeName(type)
{
	if (type == 1)
		return "管理员";
	else if(type == 3)
		return "经销商";
	else 
		return "超市";
}

function DoServerRight(accountID,accountName)
{
	initData(accountID,accountName);
	$("#perServer").show();
}

function DoModuleRights(accountID,accountName)
{
	initMouldeRightData(accountID,accountName);
	$("#perAccount").show();
}

function DoGroup(accountID,accountName)
{
	initAccountGroupData(accountID,accountName);
	$("#perGroup").show();
}

function checkAccount()
{
	var AccountID = $("#"+_pageAccountID).val(); 
	if (Trim(AccountID) == "") {
		setOnbur(_pageAccountID,"帐号不能为空！");
		return false;
	}
	if (strlen(Trim(AccountID)) < 1 || strlen(Trim(AccountID)) > 50) {
		setOnbur(_pageAccountID,"帐号长度要在50字符之内！");
		return false;
	}
	setOnbur(_pageAccountID,"");
	return true;
}

function checkName()
{
	var NickName = $("#"+_pageNickName).val();
	if(Trim(NickName) == ""){
		setOnbur(_pageNickName,"姓名不能为空！");
		return false;
	}
	if (strlen(Trim(NickName)) < 0 || strlen(Trim(NickName)) > 50) {
        setOnbur(_pageNickName,"姓名长度要在50字符之内！");
        return false;
    }
	setOnbur(_pageNickName,"");
	return true;
}

function checkAccountType()
{
	var AccountType = document.getElementById(_pageSelectAccountType);
    if (AccountType != null) {
        if (AccountType.value == "-1") {
        	setOnbur(_pageSelectAccountType,"请选择帐号类别！");
            return false;
        }
    }
    setOnbur(_pageSelectAccountType,"");
	return true;
}

function checkAccountLevel()
{
	var AccountLevel = document.getElementById(_pageSelectAccountLevel);
    if (AccountLevel != null) {
        if (AccountLevel.value == "-1") {
        	setOnbur(_pageSelectAccountLevel,"请选择帐号等级！");
            return false;
        }
    }
    setOnbur(_pageSelectAccountLevel,"");
	return true;
}

function checkPhone()
{
	var Phone = $("#"+_pagePhone).val();
    if (Phone != null) {
        if (strlen(Trim(Phone)) < 0 || strlen(Trim(Phone)) > 50) {
        	setOnbur(_pagePhone,"电话要在50字符之内!");
            return false;
        }
    }
	setOnbur(_pagePhone,"");
	return true;
}

function checkEmail()
{
	var Email = $("#"+_pageEmail).val();
	if (Trim(Email) == "") {
		setOnbur(_pageEmail,"Email不能为空！");
        return false;
    }
	if (strlen(Trim(Email)) < 1 || strlen(Trim(Email)) > 50) {
        setOnbur(_pageEmail,"Email要在50字符之内！");
        return false;
    }
    if (!isEmail(Email)) {
        setOnbur(_pageEmail,"Email地址不合法！");
        return false;
    }
    setOnbur(_pageEmail,"");
	return true;
}

function checkQQ()
{
	var QQ = $("#"+_pageQQ).val();
	if (strlen(Trim(QQ)) < 0 || strlen(Trim(QQ)) > 50) {
		setOnbur(_pageQQ,"QQ要在50字符之内！");
        return false;
    }
	setOnbur(_pageQQ,"");
	return true;
}

function checkAdress()
{
	var Address = $("#"+_pageAddress).val();
	if (strlen(Trim(Address)) < 0 || strlen(Trim(Address)) > 100) {
		setOnbur(_pageAddress,"地址要在100字符之内！");
        return false;
    }
	setOnbur(_pageAddress,"");
	return true;
}

function checkRemark()
{
	var ARemark = $("#"+_pageARemark).val();
	if (strlen(Trim(ARemark)) < 0 || strlen(Trim(ARemark)) > 200) {
        setOnbur(_pageARemark,"备注要200字符之内！");
        return false;
    }
	setOnbur(_pageARemark,"");
	return true;
}

function initEditData(data)
{
	$("#"+_pageAccountID).val(data == null ? "" : data.account);
	$("#"+_pageNickName).val(data == null ? "" : data.acct_name);
	document.getElementById(_pageSelectAccountType).value = data == null ? 2 : data.acct_type;
	document.getElementById(_pageSelectAccountLevel).value = data == null ? 1 : data.acct_level;
	//$("#"+_pagePhone).val(data == null ? "" : data.bm_Phone);
	//$("#"+_pageEmail).val(data == null ? "" : data.bm_Email);
	//$("#"+_pageQQ).val(data == null ? "" : data.bm_QQ);
	//$("#"+_pageAddress).val(data == null ? "" : data.bm_Address);
	$("#"+_pageARemark).val(data == null ? "" : data.acct_remark);
	setOnbur(_pageAccountID,"");
	setOnbur(_pageNickName,"");
	setOnbur(_pageSelectAccountType,"");
	setOnbur(_pageSelectAccountLevel,"");
	//setOnbur(_pagePhone,"");
	//setOnbur(_pageEmail,"");
	//setOnbur(_pageQQ,"");
	//setOnbur(_pageAddress,"");
	setOnbur(_pageARemark,"");
}