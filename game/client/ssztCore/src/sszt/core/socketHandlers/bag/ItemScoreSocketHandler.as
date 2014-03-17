package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemScoreSocketHandler extends BaseSocketHandler
	{
		public function ItemScoreSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_SCORE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(place:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_SCORE);
			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}