package sszt.core.socketHandlers.vip
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class VipMapEnterSocketHandler extends BaseSocketHandler
	{
		public function VipMapEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.VIP_MAP_ENTER;
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send(type:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.VIP_MAP_ENTER);
			pkg.writeInt(type);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}