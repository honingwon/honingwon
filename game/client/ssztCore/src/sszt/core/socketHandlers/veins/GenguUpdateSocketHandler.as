package sszt.core.socketHandlers.veins
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.veins.VeinsListUpdateEvent;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.data.veins.VeinsInfo;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GenguUpdateSocketHandler extends BaseSocketHandler
	{
		public function GenguUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VEINS_GENGU_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			var acupointType:int = _data.readInt();
			var veins:VeinsInfo = GlobalData.veinsInfo.getVeinsByAcupointType(acupointType);
			if(veins)
			{
				veins.genguLv = _data.readInt();
				veins.luck = _data.readInt();
			}
			
			GlobalData.veinsInfo.dataUpdate(VeinsListUpdateEvent.UPDATE_GENGU, {a:success,b:acupointType});
			handComplete();
		}
		
		public static function send(id:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.VEINS_GENGU_UPDATE);
			pkg.writeInt(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}