package sszt.core.data.openActivity
{
	import flash.utils.Dictionary;

	public class OpenActivityInfo
	{
		
		private var _activityInfo:Array;
		
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
		}
		
		
		public function isGetAward(groupId:int):Boolean
		{
			var obj:Object = activityDic[groupId];
			if(obj && obj.idArray && (obj.idArray as Array).length >0 )
			{
				return true;
			}
			return false;
		}

	}
}