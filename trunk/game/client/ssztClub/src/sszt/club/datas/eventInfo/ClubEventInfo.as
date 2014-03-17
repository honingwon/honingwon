package sszt.club.datas.eventInfo
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubEventUpdateEvent;
	import sszt.club.socketHandlers.ClubEventAddSocketHandler;
	
	public class ClubEventInfo extends EventDispatcher
	{
		public var total:int;
		public var clubEventList:Array;
		
		private const MAX_COUNT:int = 30;
		
		public function ClubEventInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
//		public function updateList(list:Vector.<ClubEventItemInfo>):void
		public function updateList(list:Array):void
		{
			clubEventList = list;
			dispatchEvent(new ClubEventUpdateEvent(ClubEventUpdateEvent.CLUE_EVENT_UPDATE));
		}
		
//		public function addEvent(mes:String):void
//		{
//			ClubEventAddSocketHandler.send(mes);
//			var info:ClubEventItemInfo = new ClubEventItemInfo();
//			info.type = 1;
//			info.mes = mes;
//			clubEventList.push(info);
//			if(clubEventList.length > MAX_COUNT)
//				clubEventList.shift();
//			dispatchEvent(new ClubEventUpdateEvent(ClubEventUpdateEvent.CLUE_EVENT_UPDATE));
//		}
		
		public function dispose():void
		{
			clubEventList = null;
		}
	}
}