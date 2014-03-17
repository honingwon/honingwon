package sszt.club.datas.lottery
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubLotteryInfoUpdateEvent;
	
	public class ClubLotteryInfo extends EventDispatcher
	{
		public static const TIMES_MAX:int = 5;
		
		public var times:int;
		public var itemTemplateId:int;
		
		public function updateTimes(value:int):void
		{
			times = value;
			dispatchEvent(new ClubLotteryInfoUpdateEvent(ClubLotteryInfoUpdateEvent.UPDATE_TIMES))
		}
		
		public function updateItemTemplateId(value:int):void
		{
			itemTemplateId = value;
			dispatchEvent(new ClubLotteryInfoUpdateEvent(ClubLotteryInfoUpdateEvent.UPDATE_ITEM_ID))
		}
	}
}