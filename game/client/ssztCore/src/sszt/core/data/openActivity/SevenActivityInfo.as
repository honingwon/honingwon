package sszt.core.data.openActivity
{
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.SevenActivityItemInfo;

	public class SevenActivityInfo
	{
		//废弃
		public var isInit:Boolean;
		//废弃
		private var _activityInfo:Array;
		//废弃
		private var _activityDic:Dictionary = new Dictionary();		
		
		//第一次登录游戏的时间
		public var firstLoginTime:int;
		//橙装奖励领取状态
		public var gotState:int;
		//全民奖励领取
		public var gotState2:int;			
		
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
			var nowTime:Number = GlobalData.systemDate.getSystemDate().time/1000;//秒
			var seconds:Number = nowTime - firstLoginTime;
			var secondPerDay:Number = 24*60*60;
			var t:Number = seconds/secondPerDay;
			ret = Math.ceil(t);
			return ret;
		}
	}
}