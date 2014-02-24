var _class_serverRights = null;
$(document).ready(function() {
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	
	$("input[name='sType']:radio").click(function(){
		radioClickValueChange($(this).val());
	});
	$("#nick_name_tr").show();
	$("#user_name_tr").hide();
	$("#d1").show();
	$("#d2").hide();
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
});

function radioClickValueChange(value)
{
	if(value == 1)
	{
		$("#nick_name_tr").hide();
		$("#user_name_tr").show();
		
	}
	else
	{
		$("#nick_name_tr").show();
		$("#user_name_tr").hide();
	}
}



function btnSumbitOnclickHandler()
{
	clean();
	var doneType = $("input[name='sType']:checked").val(); 
	var userName	= $("#user_name").val();
	var selectValue = _class_serverRights.getBoxValue();
	if(selectValue == null || selectValue == "")
	{
		setOnburPline("sArea","请选择合作商！");
		return;
	}
	else
		setOnburPline("sArea","");
	$("#btnSubmit").hide();
	setOnburPline("btnSubmit","正在查询... 请耐心等待，不要刷新页面！");
	$.ajax({type: "post",url: 'interface/DataAbalysisManageMethod.php',
		dataType: "json",
		data: {
				"method":"searchuserinfo",
				"type":parseInt(doneType),
				"username":userName,
				"server":selectValue},
		success: function(result) {
			if(result.Success){
				FormatData(result,selectValue,doneType);
				setOnburPline("btnSubmit","");
			}
			else{
				setOnburPline("btnSubmit",result.Message);
			}
			$("#btnSubmit").show();
		},
		error: function(e) {
			$("#btnSubmit").show();
			setOnburPline("btnSubmit",'out data config 检查这个服配置信息');
		}
	});
}

function FormatData(objData,selectValue,doneType)
{

	if (objData == null || objData.Success == false) {
        setOnburPline("btnSubmit",'暂未有数据信息');
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0 || DataList[0] == null   ) {
    	setOnburPline("btnSubmit",'暂时未有数据');
        return;
    }
    if(doneType != 2)
    {
    	$("#d1").show();
    	$("#d2").hide();
    	 
	    var Data = DataList[0];
	    $("#t1").html(Data[1]+"("+Data[0]+")");
	    for(var i=2 ;i<13 ;++i)
	    {
	    	$("#t"+i).html(Data[i]);
	    }
    }
    else
    {
    	$("#d1").hide();
    	$("#d2").show();
        var i = 0;
        var Data = DataList[i];
        var html =''; 
        while (Data != null) {
        	var num = i + 1;
        	var className = num % 2 == 0 ? "even":"";
        	html += "<tr class='"+className+"'><td>"+Data[0]+"</td><td>"+Data[1]+"</td><td>"+Data[2]+"</td><td>"+Data[3]+"</td><td>"+Data[4]+"</td> <td>[<a href=\"javascript:void(0);\" onclick=\"javascript:forbidLogin(" + Data[0] + ",\'"+selectValue+"\')\">禁登</a>]</td></tr>";
            i++;
            Data = DataList[i];
        }
        $("#List_Body").html(html);
    }
    
    
}
function clean()
{
	$("#d1").show();
	$("#d2").hide();
	 for(var i=1 ;i<13 ;++i)
	    {
	    	$("#t"+i).html("");
	    }
	 
	 $("#List_Body").html("");
}

function forbidLogin(Id,selectValue)
{
	$.ajax({type: "post",url: 'interface/AdminInterface.php',
		dataType: "json",
		data: {"method":"forbidbyid","user_id":Id,"server":selectValue},
		success: function(result) {
			if(result.Success){
				var error = "";
				if(result.DataList.length > 0)
				{
					for (var i = 0; i < result.DataList.length; i++) {
						error +=  result.DataList[i]+"<br />";
					}
				}
				if(error != ""){
					alert = "操作失败，请查看错误日志<br />" + error;
				}
				else{
					alert("操作成功!");
					$("#playerNickName").val("");
					$("#forbidDesc").val("");
				}
			}
			else
				alert("操作失败!");
			$("#btnSumbit").show();
		},
		error: function(e) {
			//alert("链接出错");
			$("#btnSumbit").show(); showMsg(true,"");}
	});
}

