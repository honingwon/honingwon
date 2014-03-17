/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-5 下午3:52:52 
 * 
 */ 
package sszt.core.data.alert
{
	import flash.display.DisplayObjectContainer;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.SharedObjectManager;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MAlert2;
	import sszt.ui.event.CloseEvent;
	
	public class NoAlertType {
		
		public static const SIT_TASK_WARNNING:int = 0;
		
		private var _flag:uint;
		private var _type:int;
		private var _day:int;
		public var _dataList:Object;
		
		public function NoAlertType(){
			_dataList = new Object();
			super();
		}
		public function get dataList():Object{
			var ta:Array;
			var index:int;
			var obj:String = SharedObjectManager.noAlertSO.value;
			var day1:int = GlobalData.systemDate.getSystemDate().date;
			var arr:Array = obj.split("|");
			if (day1 != parseInt(arr[0])){
				arr = [day1];
			}
			_day = day1;
			var i:int = 1;
			while (i < arr.length) {
				ta = arr[i].split(",");
				index = int(ta[0]);
				ta.shift();
				_dataList[index] = ta;
				i++;
			}
			return (_dataList);
		}
		
		public function saveByType(type:int, value:Boolean=true):void{
			if (!(_dataList[GlobalData.selfPlayer.userId])){
				_dataList[GlobalData.selfPlayer.userId] = new Array();
			}
			var index:int = _dataList[GlobalData.selfPlayer.userId].indexOf(type.toString());
			if (((value) && ((index == -1)))){
				_dataList[GlobalData.selfPlayer.userId].push(type.toString());
			} 
			else {
				if (index != -1){
					_dataList[GlobalData.selfPlayer.userId].splice(index, 1);
				}
			}
			save();
		}
		
		public function set dataList(value:Object):void{
			_dataList = value;
			save();
		}
		
		public function save():void{
			var i:Object;
			var str:String;
			var arr:Array = [_day];
			for (i in _dataList) {
				str = (i.toString() + ",");
				str = (str + _dataList[i].join(","));
				arr.push(str);
			}
			SharedObjectManager.noAlertSO.value = arr.join("|");
			SharedObjectManager.save();
		}
		
		public function show(message:String="", title:String=null, flags:uint=4, parent:DisplayObjectContainer=null, closeHandler:Function=null, type:int=-1, checkBoxLabel:String="", textAlign:String="center", width:Number=-1, closeAble:Boolean=true, applyStyle:Boolean=true, mod:Number=0, toCenter:Boolean=true):MAlert{
			_flag = flags;
			_type = type;
			if (dataList[GlobalData.selfPlayer.userId] && _dataList[GlobalData.selfPlayer.userId].indexOf(String(_type)) != -1)
			{
				if (closeHandler != null){
					(closeHandler(new CloseEvent(CloseEvent.CLOSE, false, false, MAlert2.getCurrentType(_flag))));
				}
				return (null);
			}
			var alert:MAlert = MAlert2.show(message, title, flags, parent, tempFun, textAlign, width, closeAble, applyStyle, checkBoxLabel, mod, toCenter);
			MAlert2(alert).setNoAlertData(closeHandler, _type);
			return (alert);
		}
		private function tempFun(evt:CloseEvent):void{
			var type:int;
			var index:int;
			var arr:Array = (evt.data as Array);
			if (evt.isSelected && evt.detail == MAlert2.getCurrentType(_flag)){
				type = arr[1];
				if (!_dataList[GlobalData.selfPlayer.userId]){
					_dataList[GlobalData.selfPlayer.userId] = new Array();
				}
				index = _dataList[GlobalData.selfPlayer.userId].indexOf(String(type));
				if (index == -1){
					_dataList[GlobalData.selfPlayer.userId].push(String(type));
				} 
				else {
					_dataList[GlobalData.selfPlayer.userId][index] = String(type);
				}
				save();
			}
			var closeHandler:Function = arr[0];
			if (closeHandler != null){
				(closeHandler(evt));
			}
		}
		public function hasSaved(type:int):Boolean{
			if (GlobalData.noAlertType.dataList[GlobalData.selfPlayer.userId] && GlobalData.noAlertType.dataList[GlobalData.selfPlayer.userId].indexOf(String(type)) != -1){
				return true;
			}
			return false;
		}
		
	}
}
