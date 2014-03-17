package sszt.core.data.openActivity
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.activity.SevenActivityItemInfo;

	public class SevenActivityInfo
	{
		public var isInit:Boolean;
		private var _activityInfo:Array;
		public var gotState:int;
		
		private var _activityDic:Dictionary = new Dictionary();
		
		
		public function get activityInfo():Array
		{
			return _activityInfo;
		}

		public function set activityInfo(value:Array):void
		{
			_activityInfo = value;
		}

		public function get activityDic():Dictionary
		{
			return _activityDic;
		}

		public function set activityDic(value:Dictionary):void
		{
			_activityDic = value;
			isInit = true;
		}

		//是否有活动仍在进行
		public function hasActivityInProgress():Boolean
		{
			var ret:Boolean;
			var sevenActivityItemInfo:SevenActivityItemInfo;
			for each(sevenActivityItemInfo in _activityDic)
			{
				if(!sevenActivityItemInfo.isEnd) 
				{
					ret = true;
					break;
				}
			}
			return ret;
		}
		
		public function getDay():int
		{
			var ret:int =8;//8代表第八天或以后
			var sevenActivityItemInfo:SevenActivityItemInfo;
			for each(sevenActivityItemInfo in _activityDic)
			{
				if(!sevenActivityItemInfo.isEnd) 
				{
					ret = sevenActivityItemInfo.id;
					break;
				}
			}
			return ret;
		}
	}
}