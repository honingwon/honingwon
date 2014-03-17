package sszt.core.data.loginReward
{
	public class LoginRewardData
	{
		
		/**
		 * 当日连续登录奖励是否领取
		 */
		public var got:Boolean;
		/**
		 * 充值用户当日连续登录奖励是否领取
		 */
		public var gotChargeUser:Boolean;
		
		/**
		 *单人副本奖励是否领取
		 */
		public var gotDuplicate:Boolean;
		
		/**
		 * 多人副本奖励是否领取
		 */
		public var gotMultiDuplicateNum:Boolean;
		/**
		 * 离线奖励是否领取
		 */
		public var gotOffLineTimes:Boolean;
		
		/**
		 * 登录天数 
		 */
		public var login_day:int;
		/**
		 * 单人副本数量 
		 */
		public var duplicateNum:int;
		/**
		 * 多人副本数量 
		 */
		public var multiDuplicateNum:int;
		/**
		 * 离线时间 秒 
		 */
		public var offLineTimes:int;
		
		public function LoginRewardData()
		{
		}
	}
}