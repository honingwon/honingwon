var _URL = "../model/BaseData/CardApplyMethod.php";
var _msgURL = "链接出错";
var _CardList = null;
var _CardData = null;
var ClassTbodyObj = null;
var _Currenpage = 1;
var _CurrentPageLine = 20;

$(document).ready(function() {
	initCardData();
	_CardData = new CardCollection();
	$("#btnAddCard").bind("click",btnAddCardClickHandler);
	$("#btnSave").bind("click",btnAddCardApplyClickHandler);
	$("#BtncloseCardFormInfo").bind("click",function(){
		$("#tdFormName").html("");
		$("#tdApplyer").html("");
		$("#tdApplyerTime").html("");
		$("#tdChecker").html("");
		$("#tdCheckTime").html("");
		$("#tdCheckRemark").html("");
		$("#tdRemark").html("");
		$("#cardInfo").html("");
		$("#CardFormInfo").hide();
	})
	selectSortMenu(null,0);
});

function btnAddCardClickHandler()
{
	var cardTypeID = $('#selCardTypeID').val();
    //获取下拉框的文本值
    var cardTypeName = $("#selCardTypeID").find("option:selected").text();

    if (cardTypeID == "-1") {
    	setOnbur('selCardTypeID',"请选择道具卡类型!");
        return;
    }
    setOnbur('selCardTypeID',"");
    if ($('#txtNum').val() == '') {
        setOnbur('txtNum',"请填写正确填写数目!");
        return;
    }
    setOnbur('txtNum',"");

    var r = /^(0|\d{0,5})$/;
    if (!r.test($('#txtNum').val())) {
        setOnbur('txtNum',"请填写正确填写数目!");
        return;

    }
    setOnbur('txtNum',"");
    var cardNum = ($('#txtNum').val() == '' || isNaN($('#txtNum').val())) ? 0 : parseInt($('#txtNum').val());

    var card = new Card(cardTypeID, cardTypeID, cardTypeName, cardNum, 0);
    if (_CardData.indexOf(card) != -1) {
        alert('已经有相同道具卡,如果要修改数目请删除后再添加!');
        return;
    }
    else {
    	_CardData.add(card);
    }
    ClassTbodyObj = new Tbody(2, 'tbodyApplyList');
    var ophtm = cardTypeName + cardNum + "张";
    ClassTbodyObj.AddRow(new Array('<input class="btn" onclick="DelCard(this,\'' + cardTypeID + '\')" type="button" value="删除" />', ophtm), null, null, new Array("30", null));
}

function DelCard(obj, cardTypeID) {
	_CardData.removeOfKey(cardTypeID);
    obj.parentElement.parentElement.style.display = "none";
}

function btnAddCardApplyClickHandler()
{
	if(!SumbitForCheck()) return false;
	 var name = $('#txtName').val();
     var remark = $('#txtDesc').val();
     var gameStr = "";
     if (_CardData.size() > 0) {
    	 for (var i = 0; i < _CardData.size(); i++) {
        	 if(_CardData.get(i).CardTypeID == null || _CardData.get(i).CardNum == null)
        		 continue;
        	 var CardTypeIDS = _CardData.get(i).CardTypeID == null ? "''" : _CardData.get(i).CardTypeID;
             var CardNumS = _CardData.get(i).CardNum == null ? "''" : _CardData.get(i).CardNum;
        	 gameStr += "(NULL,"+CardTypeIDS+","+CardNumS+")";
         }
     }
     var dataStr = {"method": "creat","name":name,"dec":remark,"str":gameStr};
     $.ajax({type: "post",url: _URL,dataType: "json",data: dataStr,
    	 success: function(result) {
    	 	if(result.Success){
    	 		if(result.Message == ""){
    	 			$(".tagSort a").removeClass();
    	 			$("#a_one").addClass("selected");
    	 			selectSortMenu(null,0);
    	 		}
    	 		else{
    	 			alert(result.Message);
    	 		}
    	 		
    	 	}
    	 	else
    	 		alert(result.Message);
     	},
     	error: function(e) {alert(_msgURL);}
     });
}

function SumbitForCheck() {
    if (_CardData.size() == 0) {
        alert("道具卡未添加!");
        return false;
    }
    setOnbur('selCardTypeID', '');
    
    var name = Trim($('#txtName').val());
    if (strlen(name) < 1 || strlen(name) > 32) {
    	setOnbur('txtName', '申请名称在1-32个字符之内');
        return false;
    }
    setOnbur('txtName', '');
    if (strlen(Trim($('#txtDesc').val())) < 1 || strlen(Trim($('#txtDesc').val())) > 128) {
    	setOnbur('txtDesc', '申请说明在1-128个字符之内');
        return false;
    }
    setOnbur('txtDesc', '');
    return true;
}

function initCardData(){
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "cardlist"},
		success: function(result) {
			if(result.Success){
				_CardList = result.DataList;
				setSelOptions();
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

function setSelOptions()
{
	var object = $("#selCardTypeID")[0];
	object.options.length = 0;
	object.options.add(new Option("请选择卡种类", "-1"));
	if (_CardList != null && _CardList.length > 0) {
        for (var i = 0; i < _CardList.length; i++) {
        	var row = _CardList[i];
        	object.options.add(new Option(row.cardTypeName, row.cardTypeID));
        }
    }
}

function selectSortMenu(obj,num){	
	if(obj!=null){
	$(".tagSort a").removeClass();
	$(obj).addClass("selected");
	}
	_Currenpage = 1;
	switch(num)
	{
		case 0:
			$("#list1").show();
			$("#tbEdit").hide();
			$("#list2").hide();$("#list3").hide();$("#list4").hide();
			LoadDataApply(0);
			break;
		case 1:
			$("#list1").hide();
			$("#tbEdit").show();
			$("#list2").hide();$("#list3").hide();$("#list4").hide();
			$('#txtName').val("");
			$('#txtDesc').val("");
			$('#selCardTypeID').val(-1);
			$('#txtNum').val("");
			if (ClassTbodyObj != null) {
                ClassTbodyObj.DelAll();
            }
			_CardData = new CardCollection();
			break;
		case 2:
			$("#list1").hide();
			$("#tbEdit").hide();
			$("#list2").show();$("#list3").hide();$("#list4").hide();
			LoadDataApply(1);
			break;
		case 3:
			$("#list1").hide();
			$("#tbEdit").hide();
			$("#list2").hide();$("#list3").show();$("#list4").hide();
			LoadDataApply(11);
			break;
		case 4:
			$("#list1").hide();
			$("#tbEdit").hide();
			$("#list2").hide();$("#list3").hide();$("#list4").show();
			LoadDataApply(2);
			break;
	}
}

function LoadDataApply(type)
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "applyList","curpage":_Currenpage,"pagesize":_CurrentPageLine,"s":type},
		success: function(result) {
			switch(type){
			case 0:
				FormatData1(result);
				break;
			case 1:
				FormatData2(result);
				break;
			case 11:
				FormatData3(result);
				break;
			case 2:
				FormatData4(result);
				break;
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}
function FormatData1(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body1").html("<tr><td colspan='4' class='tc_rad'>系统忙，请稍后</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body1").html("<tr><td colspan='4' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:ShowCardInfo(\'' + row.cardFormID + '\')">查看道具卡信息</a>]';
    	html += "<tr class='"+className+"'><td>"+row.cardFormName+"</td><td>"+row.cardApplyer+"</td><td class='tc_gray'>"+row.cardApplyTime+"</td><td class='operate'>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange1", "divPagination", 1);
    $("#List_Body1").html(html);
}

function PageChange1(num)
{
	_Currenpage = num
	LoadDataApply(0);
}

function FormatData2(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body2").html("<tr><td colspan='6' class='tc_rad'>系统忙，请稍后</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body2").html("<tr><td colspan='6' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:ShowCardInfo(\'' + row.cardFormID + '\')">查看道具卡信息</a>]';
    	ophtm += '[<a href="javascript:void(0);" onclick="ShowCollect(' + i + ',\'' + escape(row.cardFormName) + '\',\'' + escape(row.cardFormRemark) + '\');" >提取</a>]<br />';
    	ophtm += '<div id="CollectDiv' + i + '" style="display:none;"><input id="txtFile' + i + '" type="text" size="16" /> <input id="btnFile' + i + '" class="btn" type="button" value="确定" onclick="Collect(' + row.cardFormID + ',' + i + ',\'' + escape(row.cardFormName) + '\',\'' + escape(row.cardFormRemark) + '\');" /></div>';
    	var checkTime = row.cardCheckTime == null ? "" : row.cardCheckTime;
    	html += "<tr class='"+className+"'><td>"+row.cardFormName+"</td><td>"+row.cardApplyer+"</td><td class='tc_gray'>"+row.cardApplyTime+"</td><td>"+row.cardFormChecker+"</td><td class='tc_gray'>"+checkTime+"</td><td class='operate'>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange2", "divPagination", 1)
    $("#List_Body2").html(html);
}
function PageChange2(num)
{
	_Currenpage = num
	LoadDataApply(1);
}
function ShowCollect(index,name,remark)
{
	if ($("#DivInfo").css("visibility") == "visible") { $("#DivInfo").css("visibility", "hidden"); }
    if ($('#CollectDiv' + index).is(":visible")) {
        $('#CollectDiv' + index).hide();
    } else {
        $('#CollectDiv' + index).show();
    }
    //获取Cookie的值
    var FilePath = $.cookie('The_Cookie_FilePath');
    if (FilePath == null) {
        $.cookie('The_Cookie_FilePath', 'D:\\', { path: '/', expires: 365 });
        var NewCookie = $.cookie('The_Cookie_FilePath');
        $('#txtFile' + index).val(NewCookie);
    } else {
        $('#txtFile' + index).val(FilePath);
    }
}

function Collect(opIndex, index, name, remark)
{
	OPIndex = opIndex;
    var sDirectoryName = Trim($("#txtFile" + index).val()) + "\\";
    if (!validFile(sDirectoryName)) { alert("目录非法,请重新输入！"); return; }
    //删除Cookie
    $.cookie('The_Cookie_FilePath', null, { path: '/' });
    //保存Cookie
    var Cookie_FilePathTemp = $('#txtFile' + index).val();
    $.cookie('The_Cookie_FilePath', Cookie_FilePathTemp, { path: '/', expires: 365 });

    var fileAcitve;
    try {
        fileAcitve = new ActiveXObject("Scripting.FileSystemObject");
    }
    catch (ex) {
        alert(ex.message);
        return false;
    }
    if (fileAcitve == null) { alert("请运行ActiveX控件！"); return; }
    if (!fileAcitve.FolderExists(sDirectoryName)) { alert("输入的目录不存在！请核对后再输入"); return; }
//    this.ShowApplPlan();
//    $('#PlanInfo_Title').html('正在获取申请道具卡信息...');
//    var EmailBody = "\r\n    道具卡请单序号:" + OPIndex + "\r\n    道具卡请单名称:" + unescape(name) + "\r\n    申请单备注:" + unescape(remark);
//    var Data = PayCard.CardApply_Item.GetCList(this.OPIndex, EmailBody).value;
//    setTimeout(function() { $('#PlanInfo_Title').html('正在保存道具卡...') }, 1000);
//    if (this.GetCard(Data, sDirectoryName, unescape(name))) {
//        this.LoadDataPass();
//        setTimeout(function() { $('#PlanInfo_Title').html('道具卡保存成功!'); }, 1000);
//    }
//    setTimeout(function() { comm.removeMask(90); comm.$hide('DivApplPlan'); }, 3000);
    $.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "Tlist","ID":opIndex},
		success: function(result) {
    		if(result.Success)
    		{
    			if(GetCard(result,sDirectoryName,unescape(name))){
    				alert("提卡成功");
    				$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "updateapply","ID":opIndex},
    					success: function(result) {
    						LoadDataApply(1);
    				},
    					error: function(e) {alert(_msgURL);}
    				});
    				
    			}
    		}
    		else
    			alert(result.Message)
		},
		error: function(e) {alert(_msgURL);}
	});
}

function GetCard(Data, Dir, name) {
    if (Data == null || Data.Success == false) {
        alert("系统忙");
        return false;
    }
    else {
        var DataList = Data.DataList;
        if (DataList == null || DataList.length == 0) {
            alert('没有道具卡数据！');
            return false;
        }
        else {
            var i = 0;
            var row = DataList[i];
            var fileAcitve, fileCard;
            while (row != null) {
            try {
              fileAcitve = new ActiveXObject("Scripting.FileSystemObject");
              if (fileAcitve == null) return false;
              var sFileName = row[0][2]+ "_" + name + "_" + getDate() + ".txt";
              fileCard = fileAcitve.CreateTextFile(Dir + sFileName, true);
              if (fileCard == null) {
                  alert("文件创建失败,请检查你对这个目录是否有权限！");
                  return false;
              }
              fileCard.WriteLine("道具卡SN           道具卡密");
            }
            catch (ex) {
            	alert(ex.message + " 文件创建失败！"); return false;
            }
            for(var n= 0; n < row.length;++n){
               try {
                   fileCard.WriteLine(row[n][0] + "   " + row[n][1]);
               }
               catch (ex) {
                   alert(ex.message + "写入失败");
               }
            }
            i++;
            row = DataList[i];
            }
            try {
                fileCard.Close();
            }
            catch (ex) {
                alert(ex.message);
                return false;
            }
        }
    }
    return true;
}

function FormatData3(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body3").html("<tr><td colspan='6' class='tc_rad'>系统忙，请稍后</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body3").html("<tr><td colspan='6' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:ShowCardInfo(\'' + row.cardFormID + '\')">查看道具卡信息</a>]';
    	var checkTime = row.cardCheckTime == null ? "" : row.cardCheckTime;
    	html += "<tr class='"+className+"'><td>"+row.cardFormName+"</td><td>"+row.cardApplyer+"</td><td class='tc_gray'>"+row.cardApplyTime+"</td><td>"+row.cardFormChecker+"</td><td class='tc_gray'>"+checkTime+"</td><td class='operate'>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange3", "divPagination", 1)
    $("#List_Body3").html(html);
}
function PageChange3(num)
{
	_Currenpage = num
	LoadDataApply(11);
}
function FormatData4(objData)
{
	if (objData == null || objData.Success == false) {
        $("#List_Body4").html("<tr><td colspan='6' class='tc_rad'>系统忙，请稍后</td></tr>");
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0) {
    	$("#List_Body4").html("<tr><td colspan='6' class='tc_rad'>暂时未有数据</td></tr>");
        return;
    }
    var i = 0;
    var row = DataList[i];
    var html ="";
    while (row != null) {
    	var num = i + 1;
    	var className = num % 2 == 0 ? "even":"";
    	var ophtm = '[<a href="javascript:void(0);" onclick="javascript:ShowCardInfo(\'' + row.cardFormID + '\')">查看道具卡信息</a>]';
    	var checkTime = row.cardCheckTime == null ? "" : row.cardCheckTime;
    	html += "<tr class='"+className+"'><td>"+row.cardFormName+"</td><td>"+row.cardApplyer+"</td><td class='tc_gray'>"+row.cardApplyTime+"</td><td>"+row.cardFormChecker+"</td><td class='tc_gray'>"+checkTime+"</td><td class='operate'>"+ophtm+"</td></tr>";;
        i++;
        row = DataList[i];
    }
    var FSumCount = objData.Tag;
    var FPageCount = Math.ceil(FSumCount / _CurrentPageLine);
    var pagingation = new Pagination("Pagination1", FPageCount, _Currenpage, FSumCount, _CurrentPageLine, "PageChange4", "divPagination", 1)
    $("#List_Body4").html(html);
}

function PageChange4(num)
{
	_Currenpage = num
	LoadDataApply(2);
}

function ShowCardInfo(Value)
{
	$.ajax({type: "post",url: _URL,dataType: "json",data: {"method": "cardInfo","ID":Value},
		success: function(result) {
			if(result.Success){
				if(result.DataList.length >=1){
					var cardInfo = result.DataList[0][0];
					$("#tdFormName").html(cardInfo.cardFormName);
					$("#tdApplyer").html(cardInfo.cardApplyer);
					$("#tdApplyerTime").html(cardInfo.cardApplyTime);
					$("#tdChecker").html(cardInfo.cardFormChecker);
					$("#tdCheckTime").html(cardInfo.cardCheckTime);
					$("#tdCheckRemark").html(cardInfo.cardCheckRemark);
					$("#tdRemark").html(cardInfo.cardFormRemark);
					$("#CardFormInfo").show();
				}
				if(result.DataList.length >=2){
					var itemInfo = result.DataList[1];
					var html ="";
					for(var i = 0;i< itemInfo.length;++i){
						if(html!="")
							html += "</br>";
						html += itemInfo[i][3] + "&nbsp;"+itemInfo[i][2]+"张;";
					}
					$("#cardInfo").html(html);
				}
				
			}
			else{
				if(result.Message != "")
					alert(result.Message);
				else
					alert("执行错误");
			}
		},
		error: function(e) {alert(_msgURL);}
	});
}

//---------------------------------------------------------------------------------------

Card = BMClass.create();
Card.prototype = {
    initialize: function(key, CardTypeID, CardTypeName, CardNum, CardRebate) {
        this.key = key;
        this.CardTypeID = CardTypeID;
        this.CardTypeName = CardTypeName;
        this.CardNum = CardNum;
        this.CardRebate = CardRebate;
    },
    equals: function(card) {
        if (card.key == this.key) {
            return true;
        }
        else return false;
    },
    equalsofkey: function(key) {
        if (key == this.key) {
            return true;
        }
        else return false;
    }
};

CardCollection = BMClass.create();
CardCollection.prototype = {
    initialize: function() {
        this.Cards = new ArrayList();
    },
    add: function(card) {
        this.Cards.add(card);
    },
    remove: function(card) {
        var it = this.Cards.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(card)) {
                this.Cards.remove(p);
                break;
            }
        }
    },
    removeOfKey: function(key) {
        var it = this.Cards.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                this.Cards.remove(p);
                break;
            }
        }
    },
    update: function(card) {
        var index = this.indexOf(card);
        this.Cards.set(index, card);
    },
    size: function() {
        return this.Cards.size();
    },
    indexOf: function(card) {
        var number = 0;
        var it = this.Cards.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equals(card)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    indexOfKey: function(key) {
        var number = 0;
        var it = this.Cards.iterator();
        while (it.hasNext()) {
            var p = it.next();
            if (p.equalsofkey(key)) {
                return number;
            }
            number++;
        }
        return -1;
    },
    get: function(index) {
        return this.Cards.get(index);
    }

};
//验证目录名
function validFile(sValue) {
    return /^[a-fA-F]\:(\\[^\\\/\:\*\?\"<>\|]+)*\\*$/.test(sValue);
}