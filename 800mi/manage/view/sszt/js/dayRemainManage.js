var _class_serverRights = null;
var _rowIndex = 0;
var _rowcount = 0;
$(document).ready(function() {
	_rowIndex = 0;
	_rowcount = 0;
	_class_serverRights = new class_serverRights();
	_class_serverRights.init(1,'#sArea','#serverInfo',2);
	$("#btnSubmit").bind("click",btnSumbitOnclickHandler);
	$("#btnSubmit1").bind("click",btnSumbitOnclickHandler1);
});

function btnSumbitOnclickHandler1()
{
	_rowIndex = 0;
	_rowcount = 0;
	$("#List_Body").html('');
}

function btnSumbitOnclickHandler()
{
	var beginDate = $("#beginDate").val();
	var endDate	= $("#endDate").val();
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
				"method":"serverDayRemain",
				"beginDate":beginDate,
				"endDate":endDate,
				"server":selectValue},
		success: function(result) {
			if(result.Success){
				FormatData(result,selectValue);
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

function FormatData(objData,selectValue)
{
	if (objData == null || objData.Success == false) {
        setOnburPline("btnSubmit",'暂未有数据信息');
        return;
    }
	var DataList = objData.DataList;
    if (DataList == null || DataList.length == 0 ) {
    	setOnburPline("btnSubmit",'暂时未有数据');
        return;
    }

    var serveName = _class_serverRights.getServerName(selectValue);
    
    var j = 0;
    var row = DataList[j];
    var html =''; 
    while (row != null) {
    	 var days =  row[0].split(",");
    	 var nums =  row[1].split(",");
    	 var className = _rowcount % 2 == 0 ? "even":"";
    	 var objctId = "rowobjec_"+_rowIndex;
    	 html += "<tr id="+objctId+" class='"+className+"'>" +
			"<td>"+serveName+"</td><td>"+row[2]+"</td>";
		var t = 0;
		if(nums && nums[0]) t = nums[0];
		var i=0;
		for (i=0;i<days.length ;i++ )    
	    { 
			
			if(i==days[i])	
			{
				if(i>0)
				{
					html += "<td>"+nums[i]+"("+(nums[i]/t *100).toFixed(2) +"%)</td>" ;
				}
				else
				{
					html += "<td>"+nums[i]+"</td>" ;
				}
			}
			else html += "<td>0</td>" ;
	    } 
		if(i<9)
		{
			for (;i< 9 ;i++ )    
		    {    
				html += "<td>0</td>" ;
		    } 
		}
		html +="<td>[<a href=\"javascript:void(0);\" onclick=\"javascript:btnRemoveRowOnclickHandler(\'" + objctId + "\')\">移除</a>]</td>" +
					"</tr>";
		_rowIndex++;
		_rowcount++;
    	 
    	 j++;
         row = DataList[j];
    }
    	
    $("#List_Body").append(html);
    
  

}

function btnRemoveRowOnclickHandler(objectID)
{
	_rowcount--;
	$("#"+objectID).remove();
}