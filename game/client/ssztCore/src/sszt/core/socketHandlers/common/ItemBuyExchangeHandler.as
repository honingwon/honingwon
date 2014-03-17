package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ItemBuyExchangeHandler extends BaseSocketHandler
	{
		public function ItemBuyExchangeHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			// TODO Auto Generated method stub
			return ProtocolType.IITEM_EXCHANG_BUY;
		}
		
		override public function handlePackage():void
		{
			// TODO Auto Generated method stub
			var isSucc:Boolean = _data.readBoolean();
			var pr:int = _data.readInt();
			if(isSucc)
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.UPDATE_EXPLOIT));
				QuickTips.show(LanguageManager.getWord("ssztl.common.buySuccess"));
			}
			handComplete();
		}
		
		/**
		 *  
		 * @param shopItemId  神木203019蚕丝203016
		 * @param count 数量
		 */		
		public static function sendBuy(shopItemId:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.IITEM_EXCHANG_BUY);
			pkg.writeInt(shopItemId);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
		
	}
}