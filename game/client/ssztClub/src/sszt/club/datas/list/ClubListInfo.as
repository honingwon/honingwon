package sszt.club.datas.list
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubListInfoUpdateEvent;
	
	public class ClubListInfo extends EventDispatcher
	{
		public var total:int;
//		public var list:Vector.<ClubListItemInfo>;
		public var list:Array;
		
		public function ClubListInfo()
		{
//			list = new Vector.<ClubListItemInfo>();
			list = [];
		}
		
//		public function setList(value:Vector.<ClubListItemInfo>):void
		public function setList(value:Array):void
		{
			list = value;
			dispatchEvent(new ClubListInfoUpdateEvent(ClubListInfoUpdateEvent.SETCLUBLIST));
		}
		
		public function dispose():void
		{
			list = null;
		}
	}
}