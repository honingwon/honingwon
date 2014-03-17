package sszt.club.datas.tryin
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.TryinUpdateEvent;
	
	public class TryInlist extends EventDispatcher
	{
//		public var list:Vector.<TryinItemInfo>;
		public var list:Array;
		public var totalListNum:int;
		
		public function TryInlist()
		{
//			list = new Vector.<TryinItemInfo>();
			list = [];
		}
		
//		public function setList(value:Vector.<TryinItemInfo>):void
//		public function setList(value:Array):void
//		{
//			list = value;
//		}
		
		public function update():void
		{
			dispatchEvent(new TryinUpdateEvent(TryinUpdateEvent.TRYIN_UPDATE));
		}
		
		public function dispose():void
		{
			list = null;
		}
	}
}