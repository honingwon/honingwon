function class_serverRights()
{
	var self = this;
	this.gameId = "";
	this.clientArea;
	this.clientServer;
	var _serverDataArray = null;
	var _areaDataArray = null;
	var _inputType = 0;   // 0 =没有任何控件，1= 复选框，2=单选框     
	var _isCheckBoxAllChecked = true;
	
	/**
	 * @gameID 游戏ID
	 * @clientArea 
	 * @clientServer
	 * @inputType
	 */
	this.init = function(gameID,clientArea,clientServer,inputType)
	{
		this.gameId = gameID;
		this.clientArea = clientArea;
		this.clientServer = clientServer;
		_inputType = inputType;
		initAreaData();
		initServer();
		$(self.clientArea).change(function(){
			areaOnClickChange();
		});
	}
	/**
	 * 返回当前选中的对象ID，
	 * =null 没有选择控件；
	 * ="" 没有一个被选中；
	 * '1,2,3'；
	 */
	this.getBoxValue = function()
	{
		switch(_inputType)
		{
			case 1:
				var checkBoxString = "";
				$("input[name='class_chk']:checked").each(function(){
					if(checkBoxString == "")
						checkBoxString  = $(this).val();
					else
					checkBoxString += "," + $(this).val(); 
				})  
				return checkBoxString;
				break;
			case 2:
				return $("input[name='class_radio']:checked").val();
				break;
			default:
				return null;
				break;
		}
	}
	/**
	 * 返回当前选中的合作代理商标识
	 */
	this.getAreaValue = function()
	{
		return $(self.clientArea).val();
	}
	/**
	 * 设置初始化时，checkbox复选框不要选中
	 */
	this.setCheckBoxUnCheck = function()
	{
		_isCheckBoxAllChecked = false;
	}
	
	this.updateBoxStateInt = function(inputType)
	{
		$(self.clientServer).html("");
		$(self.clientArea).val("-1");
		_inputType = inputType;
	}
	/**
	 * 获取服务器名称
	 */
	this.getServerName = function(serverId)
	{
		var serverName = "Name";
		for (var i = 0; i < _serverDataArray.length; i++)
		{
			var row = _serverDataArray[i]; 
			if(row[0] == serverId)
			{
				serverName = row[1];
				break;
			}
		}
		return serverName;//
	}
	/**
	 * 返回所有大区数据
	 */
	this.getAreaDataArray = function()
	{
		return _areaDataArray;
	}
	
	var areaOnClickChange = function()
	{
		$(self.clientServer).html("");
		var areaID = $(self.clientArea).val();
		if(_serverDataArray == null) return;
		
		var bodyString = "";
		for (var i = 0; i < _serverDataArray.length; i++) {
			var row = _serverDataArray[i]; 
			if(row[2] == areaID){
				switch(_inputType)
				{
					case 1://复选框
						bodyString += "<input name='class_chk' type='checkbox' value='"+row[0]+"' checked='checked'>"+row[1]+"</input>&nbsp;&nbsp;";
						break;
					case 2://单选框
						if(bodyString != "")
							bodyString += "<input name='class_radio' type='radio' value='"+row[0]+"'>"+row[1]+"</input>&nbsp;&nbsp;";
						else
							bodyString += "<input name='class_radio' type='radio' value='"+row[0]+"' checked='checked'>"+row[1]+"</input>&nbsp;&nbsp;";
						break;
					default:
						bodyString += row[1]+"&nbsp;&nbsp;";
						break;
				}
			}
		}
		if(_inputType == 1)
		{
			$(self.clientServer).append("<label><input id='selectAll' name ='class_all_chk' type='checkbox' value='0' checked='checked'>全选/反选</input></label>");
			$("#selectAll").unbind("click");
			$("#selectAll").bind("click",function(){
					if(this.checked){
						$("input[name='class_chk']").attr("checked",true);
					}
					else{
						$("input[name='class_chk']").attr("checked",false);
					}
				}
			);
		}
		if(bodyString != ""){
			$(self.clientServer).append("<div class='noneBox fixed' style='height:100px;'  ><ul class='pureList'><ul class='col2'>"+bodyString+"</ul></ul></div>");
			if(_isCheckBoxAllChecked == false && _inputType == 1)
			{
				$("input[name='class_chk']").attr("checked",false);
				$("input[name='class_all_chk']").attr("checked",false);
			}
		}
		else
			$(self.clientServer).append("");
	}
		
	var initAreaData = function()
	{
		$.ajax({type: "post",url: '../model/ServerManager/serverInterface.php',dataType: "json",data: {"method":"area","ID":self.gameId},
			success: function(result) {
			if(result.Success){
				_areaDataArray = result.DataList; 
				var object = $(self.clientArea)[0];
				object.options.length = 0;
				object.options.add(new Option("请选择运营代理商", "-1"));
				if (result == null || result.Success == false){ 
					return;
				}
				if (result.DataList != null && result.DataList.length > 0) {
					for (var i = 0; i < result.DataList.length; i++) {
						var row = result.DataList[i]; 
						object.options.add(new Option(row[1], row[0]));
					}
				}
				else
					object.options.add(new Option("请选择运营代理商", "-1"));
			}
			else{
//				alert("执行失败："+result.Message);
			}
			},
			error: function(e) {
				//alert("链接出错");
				}
		});
	}
	
	var initServer = function()
	{
		$.ajax({type: "post",url: '../model/ServerManager/serverInterface.php',dataType: "json",data: {"method":"server","ID":self.gameId},
			success: function(result) {
			if(result.Success){
				_serverDataArray = result.DataList;
			}
			else{
//				alert("执行失败："+result.Message);
			}
			},
			error: function(e) {
				//alert("链接出错");
				}
		});
	}
}



