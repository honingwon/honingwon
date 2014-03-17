package sszt.club.datas.weal
{
	import flash.events.EventDispatcher;
	
	import sszt.club.events.ClubWealUpdateEvent;

	public class ClubWealInfo extends EventDispatcher
	{
		public var weekWeal:int;
		public var dayWeal:int;
		public var needExploit:int;
		public var needRich:int;
		public var canGetWeal:Boolean;
		
		public function ClubWealInfo()
		{
		}
		
		public function update():void
		{
			dispatchEvent(new ClubWealUpdateEvent(ClubWealUpdateEvent.WEAL_INFO_UPDATE));
		}
	}
}