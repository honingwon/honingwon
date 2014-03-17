package sszt.core.socketHandlers.bag
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BagExtendSocketHandler extends BaseSocketHandler
	{
		public function BagExtendSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BAG_EXTEND;
		}
		
		override public function handlePackage():void
		{
			var bag:int = _data.readInt();
			var ware:int = _data.readInt();
			var type:int = 0;
			if(bag > GlobalData.selfPlayer.bagMaxCount)
			{
				GlobalData.selfPlayer.bagMaxCount = bag;
				type = 0;
			}
			if(ware > GlobalData.selfPlayer.wareHouseMaxCount)
			{
				GlobalData.selfPlayer.wareHouseMaxCount = ware;
				type = 1;
			}
			GlobalData.bagInfo.extendBagSize(type);
			
			handComplete();
		}
		
		public static function sendExtend(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BAG_EXTEND);
			pkg.writeByte(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}