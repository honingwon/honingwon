package sszt.scene.socketHandlers.pk
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PkInviteSocketHandler extends BaseSocketHandler
	{
		public function PkInviteSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PK_INVITE;
		}
		
		public static function send(id:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PK_INVITE);
			pkg.writeNumber(id);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}