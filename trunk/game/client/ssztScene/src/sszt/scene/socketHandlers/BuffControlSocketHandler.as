package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class BuffControlSocketHandler extends BaseSocketHandler
	{
		public function BuffControlSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BUFF_CONTROL;
		}
		
		public static function send(result:Boolean):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.BUFF_CONTROL);
			pkg.writeBoolean(result);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}