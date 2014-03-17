package sszt.scene.socketHandlers.perWar
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PerWarGetAwardSocketHandler extends BaseSocketHandler
	{
		public function PerWarGetAwardSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PERWAR_WARAWARD;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PERWAR_WARAWARD);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}