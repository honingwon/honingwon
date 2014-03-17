package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	
	public class ItemBuySocketHandler extends BaseSocketHandler
	{
		public function ItemBuySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}

		override public function getCode():int
		{
			return ProtocolType.ITEM_BUY;
		}
		
		override public function handlePackage():void
		{
			var re:int = _data.readByte();
			if(re == 1)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.buySuccess"));
				ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.BUY_FLOWERS));
			}
			else if(re == 2 )
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.bagSizeNotEnough"));
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.buyFail"),LanguageManager.getWord("ssztl.common.alertTitle"));
			}
			
			
			handComplete();
		}
		
		public static function sendBuy(shopItemId:int,count:int,buyAndUse:Boolean = false):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_BUY);
			pkg.writeInt(shopItemId);
			pkg.writeInt(count);
			pkg.writeBoolean(buyAndUse);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}