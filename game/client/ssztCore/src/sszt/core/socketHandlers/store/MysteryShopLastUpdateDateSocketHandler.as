package sszt.core.socketHandlers.store
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.ui.container.MAlert;
	
	public class MysteryShopLastUpdateDateSocketHandler extends BaseSocketHandler
	{
		public function MysteryShopLastUpdateDateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MYSTERY_SHOP_LAST_UPDATE_TIMER;
		}
		
		override public function handlePackage():void
		{
			GlobalData.mysteryShopInfo.refreshUpdate(_data.readNumber()) ;
			GlobalData.mysteryShopInfo.vipTimesUpdate(_data.readByte()) ;
			handComplete();
		}
		
	}
}