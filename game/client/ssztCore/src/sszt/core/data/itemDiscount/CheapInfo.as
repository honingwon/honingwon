package sszt.core.data.itemDiscount
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.events.WelfareEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class CheapInfo extends EventDispatcher
	{	
		public var cheapItems:Array;
		
		public function CheapInfo()
		{
			cheapItems = [];
		}
		
		public function update(list:Array):void
		{
			cheapItems = list;
			ModuleEventDispatcher.dispatchModuleEvent(new WelfareEvent(WelfareEvent.DISCOUNT_UPDATE));
		}
		
		public function getItem(id:int):CheapItem
		{
			for(var i:int = 0;i<cheapItems.length;i++)
			{
				if((cheapItems[i] as CheapItem).shopInfo.id == id)
					return cheapItems[i]
			}
			return null;
		}
	}
}