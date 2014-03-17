package sszt.activity.data.itemViewInfo
{
	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.core.data.GlobalData;
	import sszt.core.utils.DateUtil;
	
	public class GiftItemInfo extends EventDispatcher
	{
		public var id:int;
		public var type:int;
		public var title:String;
		public var descript:String;
		public var linkPath:String;
		public var start_date:String;
		public var end_date:String;
		public var min_level:int;
		public var max_level:int;
		public var isGet:Boolean;
		
		public function GiftItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function readData(xml:XML):void
		{
			id = parseInt(xml.@welfare_id);
			type = parseInt(xml.@type);
			title = xml.@welfare_name;
			descript = xml.@descript;
			linkPath = xml.@http_link;
			start_date = xml.@start_date;
			end_date = xml.@end_date;
			min_level = xml.@min_level;
			max_level = xml.@max_level;
		}
		
		public function canShow():Boolean
		{
			var array1:Array = start_date.split("-");
			var array2:Array = end_date.split("-");
			var y1:int = array1[0];
			var m1:int = array1[1];
			var d1:int = array1[2];
			var y2:int = array2[0];
			var m2:int = array2[1];
			var d2:int = array2[2];
			var date:Date = GlobalData.systemDate.getSystemDate();
			var date1:Date = new Date(y1,m1-1,d1,0,0,0);
			var date2:Date = new Date(y2,m2-1,d2,0,0,0);
			if(DateUtil.getTimeBetween(date1,date) >= 0 && DateUtil.getTimeBetween(date,date2) > 0) return true;
			return false;
		}
		
		public function changeState(value:Boolean):void
		{
			isGet = value;
			dispatchEvent(new ActivityInfoEvents(ActivityInfoEvents.CHANGE_STATE));
		}
	}
}