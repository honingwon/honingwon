package sszt.store.socket
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	/**
	 *   神秘商店商品购买
	 * @author lxb
	 * 
	 */	
	public class MysteryShopBuySocketHandler extends BaseSocketHandler
	{
		public function MysteryShopBuySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MYSTERY_SHOP_BUY;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.buySuccess"));
			}
			handComplete();
		}
		
		public static function send(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MYSTERY_SHOP_BUY);
			pkg.writeByte(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}