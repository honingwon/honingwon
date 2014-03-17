package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class ItemSellSocketHandler extends BaseSocketHandler
	{
		public function ItemSellSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_SELL;
		}
		
		override public function handlePackage():void
		{
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.CLEAR_SELL_CELL));
			handComplete();
		}
		
		public static function sendSell(place:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_SELL);
			pkg.writeInt(place);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}