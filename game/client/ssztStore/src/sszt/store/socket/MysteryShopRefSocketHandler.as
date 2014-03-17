package sszt.store.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 *   神秘商店商品主动刷新
	 * @author lxb
	 * 
	 */	
	public class MysteryShopRefSocketHandler extends BaseSocketHandler
	{
		public function MysteryShopRefSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MYSTERY_SHOP_REFRESH;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.mysteryShopRefresh"));
			}
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MYSTERY_SHOP_REFRESH);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}