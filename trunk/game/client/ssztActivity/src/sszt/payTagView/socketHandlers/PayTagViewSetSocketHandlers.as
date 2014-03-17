package sszt.payTagView.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.payTagView.PayTagViewModule;
	
	public class PayTagViewSetSocketHandlers extends BaseSocketHandler
	{
		public function PayTagViewSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(templateModule:PayTagViewModule):void
		{
		}
		
		public static function remove():void
		{
			
		}
	}
}