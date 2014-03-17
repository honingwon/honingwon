package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ItemArrangeSocketHandler extends BaseSocketHandler
	{
		public function ItemArrangeSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ITEM_ARRANGE;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function sendArrange(type:int):void
		{
			var pkg:IPackageOut= GlobalAPI.socketManager.getPackageOut(ProtocolType.ITEM_ARRANGE);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}