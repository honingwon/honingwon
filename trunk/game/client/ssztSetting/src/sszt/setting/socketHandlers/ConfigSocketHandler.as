package sszt.setting.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ConfigSocketHandler extends BaseSocketHandler
	{
		public function ConfigSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CONFIG;
		}
		
		public static function sendConfig(config:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CONFIG);
			pkg.writeInt(config);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}