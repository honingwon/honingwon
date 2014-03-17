package sszt.core.socketHandlers.store
{
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemBuyBackSocketHandler extends BaseSocketHandler
	{
		public function ItemBuyBackSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_BUY_BACK;
		}
		
		override public function handlePackage():void
		{
			if(_data.readBoolean())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.buyBackSuccess"));
			}else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.buyBackFail"));
			}
			
			handComplete();
		}
		
		public static function sendBuyBack(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_BUY_BACK);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}