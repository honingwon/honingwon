package sszt.core.socketHandlers.common
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemRepairSocketHandler extends BaseSocketHandler
	{
		public function ItemRepairSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_REPAIR;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendRepair(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_REPAIR);
			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}