package sszt.core.data.stall
{
	import flash.events.Event;
	
	public class StallGoodsPanelEvents extends Event
	{
		//附带数据
//		public var _data:Object;
		public var _data:int;
		//数据加载完成消息
		public static const STALL_DATA_COMPLETE:String = "stallDataComplete"; 
		
		//待购道具栏更新
		public static const STALL_BUY_GOODS_UPDATE:String = "stallBuyGoodsUpdate";
		
		public function StallGoodsPanelEvents(type:String, data:int,bubbles:Boolean=false, cancelable:Boolean=false)
		{
//			_data = data;
			_data = data;
			super(type, bubbles, cancelable);
		}
	}
}