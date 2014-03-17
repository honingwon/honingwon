package sszt.core.socketHandlers.tradeDirect
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class TradeItemRemoveSocketHandler extends BaseSocketHandler
	{
		public function TradeItemRemoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.TRADE_ITEM_REMOVE;
		}
		
		override public function handlePackage():void
		{
			//1成功，0失败
			var result:int = _data.readByte();
			if(result)
			{
				var place:int = _data.readInt();
				var item:ItemInfo = GlobalData.bagInfo.getItem(place);
				if(item)
				{
					item.tradeLock = false;
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TRADE_ITEM_SELFREMOVE,item.itemId));
				}
			}
			
			handComplete();
		}
		
		public static function sendRemove(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.TRADE_ITEM_REMOVE);
			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}