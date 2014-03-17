package sszt.box.socketHandlers
{
	import sszt.box.BoxModule;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class BoxSetSocketHandler extends BaseSocketHandler
	{
		public function BoxSetSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		public static function addHandlers(boxModule:BoxModule):void
		{
			GlobalAPI.socketManager.addSocketHandler(new StoreItemInitSocketHandler(boxModule));
			GlobalAPI.socketManager.addSocketHandler(new MoveToBagSocketHandler(boxModule));
//			GlobalAPI.socketManager.addSocketHandler(new GainItemInitHandler(boxModule));
//			GlobalAPI.socketManager.addSocketHandler(new GainItemInfoAddHandler(boxModule));
			GlobalAPI.socketManager.addSocketHandler(new UpGainInfoInitHandler(boxModule));
			GlobalAPI.socketManager.addSocketHandler(new StoreInfoUpdateHandler(boxModule));
		}
		
		public static function removeHandlers():void
		{
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SM_SOTRE_ITEM_UPDATE);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SM_REMOVE_STORE_ITEM);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SM_GAIN_ITEM_INIT);
//			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SM_UPGAIN_ITEMINFO_ADD);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SM_NEAR_BOX_MSG);
			GlobalAPI.socketManager.removeSocketHandler(ProtocolType.SM_STORE_INFO_UPDATE);
		}
	}
}