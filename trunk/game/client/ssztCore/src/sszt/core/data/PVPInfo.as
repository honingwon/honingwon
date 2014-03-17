package sszt.core.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	
	public class PVPInfo extends EventDispatcher
	{
		public var exploit:int;
		public var pvp1_day_award:int;
		public var achieve_tiem:int;
		public var win_num:int;
		public var fail_num:int;
		public var draw_num:int;
		
		public var pvp1_flag:Boolean;//是否需要连续战斗
		public var current_active_id:int;//当前正在进行的活动 0:活动未开启
		public var user_pvp_state:int;//玩家在pvp中的状态0:不在pvp中，1:排队中，2:战斗中
		
		public function PVPInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}