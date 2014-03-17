package sszt.core.data.loginReward
{
	import flash.utils.ByteArray;

	public class LoginRewardExp
	{
		/**
		 * 种类编号 1：单人副本，2：多人副本，3：离线
		 */
		public var speciesNo:int;
		/**
		 * 基础奖励经验 
		 */
		public var basicsExp:int;
		/**
		 * 花费铜币数 
		 */
		public var copper:int;
		/**
		 * 花费铜币获得的经验
		 */
		public var copperExp:int;
		/**
		 * 花费元宝数 
		 */
		public var yuanBao:int;
		/**
		 * 花费元宝获得的经验
		 */
		public var yuanBaoExp:int;
		
		public function LoginRewardExp()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			speciesNo = data.readInt();
			basicsExp = data.readInt();
			copper = data.readInt();
			copperExp = data.readInt();
			yuanBao = data.readInt();
			yuanBaoExp = data.readInt();
		}
	}
}