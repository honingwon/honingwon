package sszt.common.vip.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.common.vip.event.VipEvent;
	
	public class VipPlayerList extends EventDispatcher
	{
		public var list:Array;
		public var isGet:Boolean = false;
		public var leftTime:int = 0;
		public var transferCount:int = 0;
		
		public function VipPlayerList(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function setViperData(list:Array):void
		{
			this.list = list;
			dispatchEvent(new VipEvent(VipEvent.VIPERDATE_COMPLETE));
		}
		
		public function setSelfData(value:Boolean,time:int,count:int):void
		{
			isGet = value;
			leftTime = time;
			count = transferCount;
			dispatchEvent(new VipEvent(VipEvent.SELFDATA_COMPLETE));
		}
	}
}