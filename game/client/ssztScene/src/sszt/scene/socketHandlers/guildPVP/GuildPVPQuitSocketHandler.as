package sszt.scene.socketHandlers.guildPVP
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GuildPVPQuitSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPQuitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_QUIT;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GUILD_PVP_QUIT);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}