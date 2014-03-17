package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemLockUpdateSocketHandler extends BaseSocketHandler
	{
		public function ItemLockUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
//		override public function getCode():int
//		{
//			return ProtocolType.ITEM_LOCK_UPDATE;
//		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendLock(place:int,value:Boolean):void
		{
//			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_LOCK_UPDATE);
//			pkg.writeInt(place);
//			pkg.writeBoolean(value);
//			GlobalAPI.socketManager.send(pkg);
		}
	}
}