package sszt.core.socketHandlers.pvp
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ActiveResourceWarEnterSocketHandler extends BaseSocketHandler
	{
		public function ActiveResourceWarEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ACTIVE_RESOURCE_WAR_ENTER
		}
		
		override public function handlePackage():void
		{
			handComplete();
		}
		
		public static function send() : void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ACTIVE_RESOURCE_WAR_ENTER);
			GlobalAPI.socketManager.send(pkg);
		} 
	}
}