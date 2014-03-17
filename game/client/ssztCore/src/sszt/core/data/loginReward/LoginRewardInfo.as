package sszt.core.data.loginReward
{
	import flash.utils.ByteArray;

	public class LoginRewardInfo
	{
		
		/**
		 * 登录天数 
		 */
		public var loginDay:int;
		/**
		 * 普通物品奖励id 
		 */
		public var ptItemId:int;
		/**
		 * 普通物品奖励数量 
		 */
		public var ptItemNum:int;
		/**
		 * vip物品奖励id 
		 */
		public var vipItemId:int;
		/**
		 * vip物品奖励数量 
		 */
		public var vipItemNum:int;
		
		public function LoginRewardInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			loginDay = data.readInt();
			ptItemId = data.readInt();
			ptItemNum = data.readInt();
			vipItemId = data.readInt();
			vipItemNum = data.readInt();
		}
	}
}