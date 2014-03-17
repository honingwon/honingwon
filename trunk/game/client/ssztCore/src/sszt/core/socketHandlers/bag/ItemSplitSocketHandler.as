package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemSplitSocketHandler extends BaseSocketHandler
	{
		public function ItemSplitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_SPLIT;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendSplit(place:int,splitCount:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_SPLIT);
			pkg.writeInt(place);
			pkg.writeInt(splitCount);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}