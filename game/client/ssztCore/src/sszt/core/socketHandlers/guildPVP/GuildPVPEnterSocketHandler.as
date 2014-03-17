package sszt.core.socketHandlers.guildPVP
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class GuildPVPEnterSocketHandler extends BaseSocketHandler
	{
		public function GuildPVPEnterSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.GUILD_PVP_ENTER;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.GUILD_PVP_ENTER);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}