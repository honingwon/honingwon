package sszt.core.socketHandlers.veins
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.veins.VeinsListUpdateEvent;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class VeinsClearCDSocketHandler extends BaseSocketHandler
	{
		public function VeinsClearCDSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VEINS_CLEAR_CD;
		}
		
		override public function handlePackage():void
		{
			var cd:Number = _data.readNumber();
			GlobalData.veinsInfo.veinsCD = cd;
			GlobalData.veinsInfo.dataUpdate(VeinsListUpdateEvent.REFASH_VEINS_CD);
			handComplete();
		}
		
		public static function send(type:int, place:int ):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.VEINS_CLEAR_CD);
			pkg.writeInt(type);
			pkg.writeInt(place);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}