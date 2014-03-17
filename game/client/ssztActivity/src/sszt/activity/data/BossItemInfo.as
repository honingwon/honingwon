package sszt.activity.data
{
	public class BossItemInfo
	{
		public var bossId:int;
		
		public var isLive:Boolean;
		
		/**
		 * 时间戳，单位：秒
		 * */
		public var deadTime:Number;
		
		/**
		 * 固定间隔时间刷新BOSS刷新剩余时间
		 */
		public var intervalRemaining:int;
		
		/**
		 * 固定时间点刷新BOSS下一刷新时间点
		 */
		public var nextTime:String;
	}
}