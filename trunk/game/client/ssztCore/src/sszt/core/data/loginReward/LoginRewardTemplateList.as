package sszt.core.data.loginReward
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class LoginRewardTemplateList
	{
		public static var _list:Dictionary = new Dictionary();
		public static var _listExp:Dictionary = new Dictionary();
		
		public function LoginRewardTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:LoginRewardInfo = new LoginRewardInfo();
				info.parseData(data);
				_list[info.loginDay] = info;
			}
		}
		
		public static function length():int
		{
			var length:int = 0;
			for(var key:String in _list)
			{
				length++;
			}
			return length;
		}
		
		public static function parseExpData(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var info:LoginRewardExp = new LoginRewardExp();
				info.parseData(data);
				_listExp[info.speciesNo] = info;
			}
		}
		
		public static function getTemplate(loginDay:int):LoginRewardInfo
		{
			return _list[loginDay];
		}
		
		public static function getExpTemplate(speciesNo:int):LoginRewardExp
		{
			return _listExp[speciesNo];
		}
	}
}