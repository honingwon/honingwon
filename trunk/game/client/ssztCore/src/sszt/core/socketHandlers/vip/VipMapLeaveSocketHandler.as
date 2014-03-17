package sszt.core.socketHandlers.vip
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class VipMapLeaveSocketHandler extends BaseSocketHandler
	{
		public function VipMapLeaveSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VIP_MAP_LEAVE;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.VIP_MAP_LEAVE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}