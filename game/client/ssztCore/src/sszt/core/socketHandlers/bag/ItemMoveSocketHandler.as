package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemMoveSocketHandler extends BaseSocketHandler
	{
		public function ItemMoveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_MOVE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendItemMove(fromType:int,fromPlace:int,toType:int,toPlace:int,count:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_MOVE);
			pkg.writeInt(fromType);
			pkg.writeInt(fromPlace);
			pkg.writeInt(toType);
			pkg.writeInt(toPlace);
			pkg.writeInt(count);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}