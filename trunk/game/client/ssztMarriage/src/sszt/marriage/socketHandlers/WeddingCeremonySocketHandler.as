package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class WeddingCeremonySocketHandler extends BaseSocketHandler
	{
		public function WeddingCeremonySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.START_WEDDING;
		}
		
		override public function handlePackage():void
		{
//			GlobalData.weddingInfo.inCeremony = true;
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.START_WEDDING);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}