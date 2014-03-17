package sszt.core.socketHandlers.task
{
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.DateUtil;
	import sszt.interfaces.socket.IPackageOut;
	
	public class StartClubTransportSocketHandler extends BaseSocketHandler
	{
		public function StartClubTransportSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.START_CLUB_TRANSPORT;
		}
		
		override public function handlePackage():void
		{
			var time:int = _data.readInt();
			GlobalData.setClubTransportTime(time);
			
			handComplete();
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.START_CLUB_TRANSPORT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}