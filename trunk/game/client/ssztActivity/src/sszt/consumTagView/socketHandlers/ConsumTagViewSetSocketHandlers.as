package sszt.consumTagView.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.consumTagView.ConsumTagViewModule;
	
	public class ConsumTagViewSetSocketHandlers extends BaseSocketHandler
	{
		public function ConsumTagViewSetSocketHandlers(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function add(templateModule:ConsumTagViewModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new ConsumTagViewInfoSocketHandler(templateModule));	
		}
		
		public static function remove():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.TEMP_1);
		}
	}
}